import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:go_router/go_router.dart';
import 'package:receipt_splitter/common/custom_radio_button.dart';
import 'package:receipt_splitter/common/custom_text_field_widget.dart';
import 'package:receipt_splitter/common/layout_builder_widget.dart';
import 'package:receipt_splitter/constants/strings.dart';
import 'package:receipt_splitter/model/tax_type.dart';
import 'package:receipt_splitter/module/receipt_detail/common/participants_item_widget.dart';
import 'package:receipt_splitter/module/receipt_detail/cubit/receipt_form_cubit/receipt_form_cubit.dart';
import 'package:receipt_splitter/module/receipt_detail/cubit/receipt_form_cubit/receipt_type_cubit.dart';
import 'package:receipt_splitter/services/date_time_service.dart';
import 'package:receipt_splitter/services/dialog_service.dart';

import '../../../model/receipt.dart';
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

class _ReceiptFormScreenState extends State<ReceiptFormScreen> {
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
    isNew = widget.arguments.isNew ?? true;
    if (isNew) {
      _dateController.text = DateTimeService.dayMonthYear(currentDate);
      receipt.date = currentDate;
    } else {
      receipt = widget.arguments.receipt ?? Receipt();
      _nameController.text = receipt.name ?? '';
      _dateController.text = DateTimeService.dayMonthYear(receipt.date ?? currentDate);
      _serviceChargeController.text = receipt.serviceCharges?.toString() ?? '0';
      _taxController.text = receipt.tax?.toString() ?? '0';
      context.read<ReceiptTypeCubit>().setType(receipt.taxType ?? TaxType.inclusive);
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
    _dateController.text = DateTimeService.dayMonthYear(currentDate);
    _serviceChargeController.clear();
    _taxController.clear();
    BlocProvider.of<ReceiptFormCubit>(context).resetForm();
  }

  void saveForm() {
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

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(isNew ? CREATE_RECEIPT : EDIT_RECEIPT, style: Theme.of(context).textTheme.titleLarge?.copyWith(color: Theme.of(context).colorScheme.onSurface)),
        centerTitle: true,
        actions: [
          isNew
              ? SizedBox.shrink()
              : IconButton(
                onPressed: () {
                  DialogService.showConfirmationDialog(context: context, title: DELETE_RECEIPT, message: DELETE_RECEIPT_MESSAGE, onConfirm: () {}, confirmText: DELETE, cancelText: CANCEL);
                },
                icon: Icon(Icons.delete),
              ),
        ],
      ),
      body: LayoutBuilderWidget(
        child: Form(
          child: BlocConsumer<ReceiptFormCubit, ReceiptFormState>(
            listener: (context, state) {
              if (state is ReceiptFormSaved) {
                context.pushNamed(ItemsAndPeopleScreen.itemsAndPeople, extra: state.receipt);
              }
            },
            builder: (context, state) {
              if (state is ReceiptFormUpdated) {
                receipt = state.receipt;
              } else if (state is ParticipantUpdated) {
                receipt.participants = state.participants;
              } else if (state is MenuItemUpdated) {
                receipt.items = state.items;
              }
              return Column(
                children: [
                  Column(
                    children: [
                      CustomTextFieldWidget(label: NAME),
                      CustomSpaceWidget(),
                      CustomTextFieldWidget(
                        controller: _dateController,
                        label: DATE,
                        onTap: () {
                          showDatePicker(context: context, initialDate: DateTime.now(), firstDate: DateTime(2021), lastDate: DateTime(2030)).then((value) {
                            if (value != null) {
                              currentDate = value;
                              _dateController.text = DateTimeService.dayMonthYear(value);
                            }
                          });
                        },
                        readOnly: true,
                      ),
                      CustomSpaceWidget(),
                      CustomTextFieldWidget(label: SERVICE_CHARGE, keyboardType: TextInputType.number, textInputAction: TextInputAction.continueAction,),
                      CustomSpaceWidget(),
                      CustomTextFieldWidget(label: TAX, keyboardType: TextInputType.number),
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
                  isNew
                      ? SizedBox.shrink()
                      : Expanded(
                        child: ParticipantsItemWidget(
                          items: receipt.items,
                          participants: receipt.participants,
                          onUpdateItem: (items, item) => BlocProvider.of<ReceiptFormCubit>(context).updateItem(items: items, item: item),
                          onUpdateParticipant: (participants, participant) => BlocProvider.of<ReceiptFormCubit>(context).updateParticipant(participants: participants, participant: participant),
                        ),
                      ),
                ],
              );
            },
          ),
        ),
      ),
      bottomNavigationBar:
          isNew
              ? Container(
                color: Theme.of(context).colorScheme.surfaceContainer,
                width: double.infinity,
                height: 80,
                child: Row(
                  children: [
                    IconButton(
                      onPressed: () {
                        resetFields();
                      },
                      icon: Icon(Icons.replay_outlined),
                    ),
                    Spacer(),
                    FloatingActionButton(onPressed: () => saveForm(), child: Icon(Icons.arrow_forward)),
                  ],
                ),
              )
              : null,
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
