import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:go_router/go_router.dart';
import 'package:receipt_splitter/common/custom_radio_button.dart';
import 'package:receipt_splitter/common/custom_text_field_widget.dart';
import 'package:receipt_splitter/constants/strings.dart';
import 'package:receipt_splitter/model/tax_type.dart';
import 'package:receipt_splitter/module/receipt_detail/common/participants_item_widget.dart';
import 'package:receipt_splitter/module/receipt_detail/cubit/receipt_form_cubit/receipt_type_cubit.dart';
import 'package:receipt_splitter/services/date_time_service.dart';
import 'package:receipt_splitter/services/dialog_service.dart';

import 'items_and_people_screen.dart';

class ReceiptFormScreen extends StatefulWidget {
  const ReceiptFormScreen({super.key, this.isNew});
  static const String receiptForm = '/receiptForm';
  final bool? isNew;

  @override
  State<ReceiptFormScreen> createState() => _ReceiptFormScreenState();
}

class _ReceiptFormScreenState extends State<ReceiptFormScreen> {
  final TextEditingController _nameController = TextEditingController();
  final TextEditingController _dateController = TextEditingController();
  final TextEditingController _serviceChargeController = TextEditingController();
  final TextEditingController _taxController = TextEditingController();
  late bool isNew;

  @override
  void initState() {
    super.initState();
    isNew = widget.isNew ?? false;
  }

  @override
  void dispose() {
    super.dispose();
    _nameController.dispose();
    _dateController.dispose();
    _serviceChargeController.dispose();
    _taxController.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(isNew ? CREATE_RECEIPT : EDIT_RECEIPT, style: Theme.of(context).textTheme.titleLarge?.copyWith(color: Theme.of(context).colorScheme.onSurface)),
        centerTitle: true,
        actions: [isNew ? SizedBox.shrink() : IconButton(onPressed: () {
          DialogService.showConfirmationDialog(context: context, title: DELETE_RECEIPT, message: DELETE_RECEIPT_MESSAGE, onConfirm: () {});
        }, icon: Icon(Icons.delete))],
      ),
      body: Form(
        child: Column(
          children: [
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 20.0, vertical: 10.0),
              child: Column(
                children: [
                  CustomTextFieldWidget(label: NAME),
                  CustomSpaceWidget(),
                  CustomTextFieldWidget(
                    controller: _dateController,
                    label: DATE,
                    onTap: () {
                      showDatePicker(context: context, initialDate: DateTime.now(), firstDate: DateTime(2021), lastDate: DateTime(2030)).then((value) {
                        if (value != null) {
                          _dateController.text = DateTimeService.dayMonthYear(value);
                        }
                      });
                    },
                    readOnly: true,
                  ),
                  CustomSpaceWidget(),
                  CustomTextFieldWidget(label: SERVICE_CHARGE),
                  CustomSpaceWidget(),
                  CustomTextFieldWidget(label: TAX),
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
            isNew ? Spacer() : SizedBox.shrink(),
            isNew
                ? Container(
                  color: Theme.of(context).colorScheme.surfaceContainer,
                  width: double.infinity,
                  height: 80,
                  child: Row(
                    children: [
                      IconButton(onPressed: () {}, icon: Icon(Icons.replay_outlined)),
                      Spacer(),
                      FloatingActionButton(
                        onPressed: () {
                          context.pushNamed(ItemsAndPeopleScreen.itemsAndPeople);
                        },
                        child: Icon(Icons.arrow_forward),
                      ),
                    ],
                  ),
                )
                : Expanded(child: ParticipantsItemWidget()),
          ],
        ),
      ),
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
