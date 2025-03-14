import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:receipt_splitter/common/custom_radio_button.dart';
import 'package:receipt_splitter/common/custom_text_field_widget.dart';
import 'package:receipt_splitter/constants/strings.dart';
import 'package:receipt_splitter/model/receipt_type.dart';
import 'package:receipt_splitter/module/receipt_detail/cubit/receipt_form_cubit/receipt_type_cubit.dart';
import 'package:receipt_splitter/services/date_time_service.dart';

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
      appBar: AppBar(title: Text('Create Receipt')),
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
                  BlocBuilder<ReceiptTypeCubit, ReceiptType>(
                    builder: (context, state) {
                      print(state.name);
                      return CustomRadioButton<ReceiptType>(
                        options: ReceiptType.values,
                        selectedValue: state,
                        onChanged: (value) {
                          context.read<ReceiptTypeCubit>().toggle();
                        },
                        labelBuilder: (type) => type == ReceiptType.inclusive ? "Inclusive" : "Exclusive",
                      );
                    },
                  ),
                ],
              ),
            ),
            Spacer(),
            Container(
              color: Theme.of(context).colorScheme.surfaceContainer,
              width: double.infinity,
              height: 80,
              child: Row(children: [IconButton(onPressed: () {}, icon: Icon(Icons.replay_outlined)), Spacer(), FloatingActionButton(onPressed: () {}, child: Icon(Icons.arrow_forward))]),
            ),
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
