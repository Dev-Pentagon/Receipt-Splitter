import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:go_router/go_router.dart';
import 'package:receipt_splitter/common/custom_radio_button.dart';
import 'package:receipt_splitter/common/custom_text_field_widget.dart';
import 'package:receipt_splitter/constants/strings.dart';
import 'package:receipt_splitter/extension/route_extension.dart';
import 'package:receipt_splitter/model/tax_type.dart';
import 'package:receipt_splitter/module/receipt_detail/common/participants_item_widget.dart';
import 'package:receipt_splitter/module/receipt_detail/cubit/receipt_form_cubit/receipt_form_cubit.dart';
import 'package:receipt_splitter/module/receipt_detail/cubit/receipt_type_cubit.dart';
import 'package:receipt_splitter/module/receipt_list/screen/receipt_list_screen.dart';
import 'package:receipt_splitter/services/dialog_service.dart';

import '../../../common/layout_builder_widget.dart';
import '../../../model/menu_item.dart';
import '../../../model/participant.dart';
import '../../../model/receipt.dart';
import '../../../util/date_time_util.dart';
import 'items_and_people_screen.dart';

class ReceiptFormScreenArguments {
  final bool? isNew;
  final Receipt? receipt;

  ReceiptFormScreenArguments({this.receipt, this.isNew});
}

class ReceiptFormScreen extends StatefulWidget {
  const ReceiptFormScreen({super.key, required this.arguments});
  static const String receiptForm = '/receiptForm';
  final ReceiptFormScreenArguments arguments;

  @override
  State<ReceiptFormScreen> createState() => _ReceiptFormScreenState();
}

class _ReceiptFormScreenState extends State<ReceiptFormScreen> with SingleTickerProviderStateMixin {
  late TabController _tabController;
  final _formKey = GlobalKey<FormState>();

  final TextEditingController _nameController = TextEditingController();
  final TextEditingController _dateController = TextEditingController();
  final TextEditingController _serviceChargeController = TextEditingController();
  final TextEditingController _taxController = TextEditingController();

  Receipt receipt = Receipt();
  DateTime currentDate = DateTime.now();

  late bool isNew;

  @override
  void initState() {
    super.initState();
    _tabController = TabController(length: 2, vsync: this);
    isNew = widget.arguments.isNew ?? true;
    if (isNew) {
      _dateController.text = DateTimeUtil.dayMonthYear(currentDate);
      receipt.date = currentDate;
    } else {
      receipt = widget.arguments.receipt ?? Receipt();
      _nameController.text = receipt.name ?? '';
      _dateController.text = DateTimeUtil.dayMonthYear(receipt.date ?? currentDate);
      _serviceChargeController.text = receipt.serviceCharges?.toString() ?? '0';
      _taxController.text = receipt.tax?.toString() ?? '0';
      context.read<ReceiptFormCubit>().setForm(receipt);
    }
  }

  @override
  void dispose() {
    super.dispose();
    _nameController.dispose();
    _dateController.dispose();
    _serviceChargeController.dispose();
    _taxController.dispose();
  }

  void resetFields() {
    _nameController.clear();
    currentDate = DateTime.now();
    _dateController.text = DateTimeUtil.dayMonthYear(currentDate);
    _serviceChargeController.clear();
    _taxController.clear();
    BlocProvider.of<ReceiptFormCubit>(context).resetForm();
  }

  void saveForm() {
    if (_formKey.currentState!.validate()) {
      receipt.name = _nameController.text;
      receipt.date = currentDate;
      receipt.serviceCharges = double.tryParse(_serviceChargeController.text) ?? 0;
      receipt.tax = double.tryParse(_taxController.text) ?? 0;
      receipt.taxType = context.read<ReceiptTypeCubit>().state;
      if (isNew) {
        BlocProvider.of<ReceiptFormCubit>(context).saveForm(receipt);
      } else {
        BlocProvider.of<ReceiptFormCubit>(context).updateForm(receipt);
      }
    }
  }

  void _addNewItem() async {
    String tab = _tabController.index == 0 ? "Participants" : "Items";
    Participant? participant;
    MenuItem? menuItem;

    if (tab == "Participants") {
      participant = await _showEditBottomSheet<Participant>(data: null, index: 0, isParticipant: true);
    } else {
      menuItem = await _showEditBottomSheet<MenuItem>(data: null, index: 0);
    }

    _updateItem(participant: participant, item: menuItem);
  }

  void _updateItem({Participant? participant, MenuItem? item}) {
    if (participant != null) {
      BlocProvider.of<ReceiptFormCubit>(context).updateParticipant(participants: receipt.participants, participant: participant, items: receipt.items, receiptId: receipt.uid!);
    } else if (item != null) {
      BlocProvider.of<ReceiptFormCubit>(context).updateItem(items: receipt.items, item: item, receiptId: receipt.uid!);
    }
  }

  void _deleteItem({Participant? participant, MenuItem? item}) {
    if (participant != null) {
      BlocProvider.of<ReceiptFormCubit>(context).deleteParticipant(participants: receipt.participants, items: receipt.items, participant: participant);
    } else if (item != null) {
      BlocProvider.of<ReceiptFormCubit>(context).deleteItem(items: receipt.items, item: item);
    }
  }

  @override
  Widget build(BuildContext context) {
    return PopScope(
      // I want to update the receipt if we click back or back button if the form is not new
      // but if the form is new, nothing will happen
      onPopInvokedWithResult: (bool didPop, Object? result) async {
        if (didPop && !isNew) {
          saveForm();
        }
      },
      child: Scaffold(
        appBar: AppBar(title: Text(isNew ? CREATE_RECEIPT : EDIT_RECEIPT, style: Theme.of(context).textTheme.titleLarge?.copyWith(color: Theme.of(context).colorScheme.onSurface)), centerTitle: true),
        body: LayoutBuilderWidget(
          top: 0,
          bottom: 0,
          child: BlocConsumer<ReceiptFormCubit, ReceiptFormState>(
            listener: (context, state) {
              if (state is ReceiptFormSaved) {
                context.pushNamed(ItemsAndPeopleScreen.itemsAndPeople, extra: state.receipt).then((value) {
                  if (context.mounted) {
                    context.pop(value);
                  }
                });
              } else if (state is ReceiptDeletedSuccessfully) {
                context.pop();
                DialogService.showSuccessDialog(context: context, title: DELETE, message: DELETE_SUCCESS, onConfirm: () {
                  context.pushNamedAndRemoveUntil(ReceiptListScreen.receiptSplit);
                });
              } else if (state is ReceiptDeletedFailed) {
                context.pop();
                DialogService.showErrorDialog(context: context, title: DELETE, message: DELETE_FAILED);
              }
            },
            builder: (context, state) {
              if (state is ReceiptFormLoaded) {
                receipt = state.receipt;
                context.read<ReceiptTypeCubit>().setType(receipt.taxType ?? TaxType.inclusive);
              } else if (state is ReceiptFormUpdated) {
                receipt = state.receipt;
              } else if (state is ParticipantUpdated) {
                receipt.participants = state.participants;
              } else if (state is MenuItemUpdated) {
                receipt.items = state.items;
              }
              return NestedScrollView(
                physics: isNew ? NeverScrollableScrollPhysics() : AlwaysScrollableScrollPhysics(),
                headerSliverBuilder: (context, innerBoxIsScrolled) {
                  return [
                    SliverToBoxAdapter(
                      child: Form(
                        key: _formKey,
                        child: Column(
                          children: [
                            const SizedBox(height: 25.0),
                            CustomTextFieldWidget(
                              label: NAME,
                              controller: _nameController,
                              validator: (value) {
                                if (value == null || value.trim().isEmpty) {
                                  return RECEIPT_NAME_NOT_EMPTY;
                                }
                                return null;
                              },
                              onChanged: (value) {
                                _formKey.currentState!.validate();
                              },
                            ),
                            CustomSpaceWidget(),
                            CustomTextFieldWidget(
                              controller: _dateController,
                              label: DATE,
                              onTap: () {
                                showDatePicker(context: context, initialDate: DateTime.now(), firstDate: DateTime(2021), lastDate: DateTime(2030)).then((value) {
                                  if (value != null) {
                                    currentDate = value;
                                    _dateController.text = DateTimeUtil.dayMonthYear(value);
                                  }
                                });
                              },
                              readOnly: true,
                            ),
                            CustomSpaceWidget(),
                            CustomTextFieldWidget(label: SERVICE_CHARGE, keyboardType: TextInputType.number, controller: _serviceChargeController),
                            CustomSpaceWidget(),
                            CustomTextFieldWidget(label: TAX, keyboardType: TextInputType.number, controller: _taxController),
                            CustomSpaceWidget(),
                            BlocBuilder<ReceiptTypeCubit, TaxType>(
                              builder: (context, state) {
                                return CustomRadioButton<TaxType>(
                                  options: TaxType.values,
                                  selectedValue: state,
                                  onChanged: (value) {
                                    context.read<ReceiptTypeCubit>().toggle();
                                  },
                                  labelBuilder: (type) => type == TaxType.inclusive ? "Inclusive" : "Exclusive",
                                );
                              },
                            ),
                          ],
                        ),
                      ),
                    ),
                  ];
                },
                body:
                    isNew
                        ? SizedBox.shrink()
                        : ParticipantsItemWidget(
                          items: receipt.items,
                          participants: receipt.participants,
                          onUpdateItem: (item) {
                            _showEditBottomSheet<MenuItem>(data: item, index: 0).then((value) {
                              if (value != null) {
                                _updateItem(item: value);
                              }
                            });
                          },
                          onUpdateParticipant: (participant) {
                            _showEditBottomSheet<Participant>(data: participant, index: 0, isParticipant: true).then((value) {
                              if (value != null) {
                                _updateItem(participant: value);
                              }
                            });
                          },
                          tabController: _tabController,
                        ),
              );
            },
          ),
        ),
        bottomNavigationBar: BottomAppBar(
          color: Theme.of(context).colorScheme.surfaceContainer,
          child: Row(
            children:
                isNew
                    ? [
                      IconButton(
                        onPressed: () {
                          resetFields();
                        },
                        icon: Icon(Icons.replay_outlined),
                      ),
                      Spacer(),
                      FloatingActionButton(onPressed: () => saveForm(), child: Icon(Icons.arrow_forward)),
                    ]
                    : [
                      IconButton(
                        onPressed: () {
                          DialogService.showConfirmationDialog(
                            context: context,
                            title: DELETE_RECEIPT,
                            message: DELETE_RECEIPT_MESSAGE,
                            onConfirm: () {
                              BlocProvider.of<ReceiptFormCubit>(context).deleteForm(receipt.uid!);
                            },
                            confirmText: DELETE,
                            cancelText: CANCEL,
                          );
                        },
                        icon: Icon(Icons.delete_outline),
                      ),
                      Spacer(),
                      FloatingActionButton(onPressed: () => _addNewItem(), child: Icon(Icons.add)),
                    ],
          ),
        ),
      ),
    );
  }

  Future<T?> _showEditBottomSheet<T>({required T? data, required int index, bool isParticipant = false}) {
    Participant? participant;
    MenuItem? item;

    if (data is Participant) {
      participant = data;
    } else if (data is MenuItem) {
      item = data;
    }

    TextEditingController participantNameController = TextEditingController(text: participant?.name);
    TextEditingController nameController = TextEditingController(text: item?.name);
    TextEditingController qtyController = TextEditingController(text: item?.quantity.toString());
    TextEditingController priceController = TextEditingController(text: item?.price.toString());

    return showModalBottomSheet<T?>(
      context: context,
      isScrollControlled: true,
      builder: (context) {
        return Padding(
          padding: EdgeInsets.only(left: 16, right: 16, bottom: MediaQuery.of(context).viewInsets.bottom + 16, top: 16),
          child: Column(
            mainAxisSize: MainAxisSize.min,
            crossAxisAlignment: CrossAxisAlignment.end,
            children: [
              const SizedBox(height: 10),
              (isParticipant)
                  ? CustomTextFieldWidget(label: NAME, controller: participantNameController)
                  : Column(
                    children: [
                      CustomTextFieldWidget(label: NAME, controller: nameController),
                      const SizedBox(height: 16),
                      CustomTextFieldWidget(label: QTY, controller: qtyController),
                      const SizedBox(height: 16),
                      CustomTextFieldWidget(label: PRICE, controller: priceController),
                    ],
                  ),
              const SizedBox(height: 16),
              Row(
                mainAxisSize: MainAxisSize.min,
                children: [
                  InkWell(
                    onTap: () async {
                      if (isParticipant) {
                        // Update participant data
                        if (participant == null) {
                          participant = await Participant.create(name: participantNameController.text);
                        } else {
                          participant = participant?.copyWith(name: participantNameController.text);
                        }
                        if (context.mounted) {
                          Navigator.pop(context, participant); // Return updated participant
                        }
                      } else {
                        // Update item data
                        if (item == null) {
                          // item = MenuItem(id: 'ITM', name: nameController.text, quantity: int.tryParse(qtyController.text) ?? 0, price: double.tryParse(priceController.text) ?? 0.0);
                          item = await MenuItem.create(name: nameController.text, quantity: int.tryParse(qtyController.text) ?? 0, price: double.tryParse(priceController.text) ?? 0.0);
                        } else {
                          // Update existing item
                          item = item?.copyWith(name: nameController.text, quantity: int.tryParse(qtyController.text) ?? item!.quantity, price: double.tryParse(priceController.text) ?? item!.price);
                        }
                        if (context.mounted) {
                          Navigator.pop(context, item); // Return updated item
                        }
                      }
                    },
                    child: Container(
                      width: 107,
                      height: 40,
                      decoration: BoxDecoration(color: Theme.of(context).colorScheme.tertiary, borderRadius: BorderRadius.all(Radius.circular(100))),
                      child: Row(
                        mainAxisSize: MainAxisSize.min,
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          Icon(Icons.save_alt, color: Theme.of(context).colorScheme.onTertiary),
                          const SizedBox(width: 10),
                          Text(SAVE, style: Theme.of(context).textTheme.labelLarge?.copyWith(color: Theme.of(context).colorScheme.onTertiary)),
                        ],
                      ),
                    ),
                  ),
                  const SizedBox(width: 16),
                  Visibility(
                    visible: data != null,
                    child: InkWell(
                      onTap: () {
                        _deleteItem(participant: participant, item: item);
                        return context.pop(null);
                      },
                      child: Container(
                        width: 107,
                        height: 40,
                        decoration: BoxDecoration(color: Theme.of(context).colorScheme.tertiary, borderRadius: BorderRadius.all(Radius.circular(100))),
                        child: Row(
                          mainAxisSize: MainAxisSize.min,
                          mainAxisAlignment: MainAxisAlignment.center,
                          children: [
                            Icon(Icons.delete, color: Theme.of(context).colorScheme.onTertiary),
                            const SizedBox(width: 10),
                            Text(DELETE, style: Theme.of(context).textTheme.labelLarge?.copyWith(color: Theme.of(context).colorScheme.onTertiary)),
                          ],
                        ),
                      ),
                    ),
                  ),
                ],
              ),
            ],
          ),
        );
      },
    );
  }
}

class CustomSpaceWidget extends StatelessWidget {
  const CustomSpaceWidget({super.key});

  @override
  Widget build(BuildContext context) {
    return const SizedBox(height: 20);
  }
}
