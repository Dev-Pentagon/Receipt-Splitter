import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:go_router/go_router.dart';
import 'package:receipt_splitter/common/empty_screen.dart';
import 'package:receipt_splitter/common/layout_builder_widget.dart';
import 'package:receipt_splitter/constants/strings.dart';
import 'package:receipt_splitter/model/receipt.dart';
import 'package:receipt_splitter/model/tax_type.dart';
import 'package:receipt_splitter/module/receipt_list/common/receipt_item.dart';
import 'package:receipt_splitter/module/receipt_list/cubit/fab_cubit.dart';
import 'package:receipt_splitter/services/dialog_service.dart';

import '../../../model/menu_item.dart';
import '../../../model/participant.dart';
import '../../receipt_detail/screen/receipt_form_screen.dart';

class ReceiptListScreen extends StatelessWidget {
  ReceiptListScreen({super.key});

  static const String receiptSplit = '/receiptSplit';

  final List<Receipt> receipt = [
    Receipt(
      id: 1,
      name: 'The Radio Bar',
      date: DateTime(2025, 3, 7),
      tax: 5,
      serviceCharges: 10,
      taxType: TaxType.inclusive,
      items: [
        MenuItem(
          id: 1,
          name: 'Fried Rice',
          quantity: 2,
          price: 9600,
          participants: [Participant(id: 1, name: 'Wunna Kyaw'), Participant(id: 2, name: 'Kayy'), Participant(id: 3, name: 'Kyaw Lwin Soe'), Participant(id: 4, name: 'Nyein Chan Moe')],
        ),
        MenuItem(id: 2, name: 'Apple Juice', quantity: 2, price: 2700, participants: [Participant(id: 1, name: 'Wunna Kyaw'), Participant(id: 2, name: 'Kayy')]),
        MenuItem(id: 3, name: 'French Fried', quantity: 1, price: 3700, participants: [Participant(id: 1, name: 'Wunna Kyaw')]),
        MenuItem(
          id: 4,
          name: 'Tom Yum Soup',
          quantity: 2,
          price: 12800,
          participants: [
            Participant(id: 1, name: 'Wunna Kyaw'),
            Participant(id: 2, name: 'Kayy'),
            Participant(id: 3, name: 'Kyaw Lwin Soe'),
            Participant(id: 4, name: 'Nyein Chan Moe'),
            Participant(id: 5, name: 'Wai Yan Kyaw'),
            Participant(id: 6, name: 'Ye Thurein Kyaw'),
          ],
        ),
        MenuItem(id: 5, name: 'Fried Noodles', quantity: 2, price: 7800, participants: [Participant(id: 1, name: 'Wunna Kyaw'), Participant(id: 2, name: 'Kayy')]),
      ],
      participants: [
        Participant(id: 1, name: 'Wunna Kyaw'),
        Participant(id: 2, name: 'Kayy'),
        Participant(id: 3, name: 'Kyaw Lwin Soe'),
        Participant(id: 4, name: 'Nyein Chan Moe'),
        Participant(id: 5, name: 'Wai Yan Kyaw'),
        Participant(id: 6, name: 'Ye Thurein Kyaw'),
      ],
    ),
  ];

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(RECEIPT_SPLITTER, style: Theme.of(context).textTheme.titleLarge?.copyWith(color: Theme.of(context).colorScheme.onSurface)),
        actions: [IconButton(icon: Icon(Icons.settings), onPressed: () {})],
        centerTitle: true,
      ),
      body: LayoutBuilderWidget(
        child:
            receipt.isNotEmpty
                ? ListView.separated(
                  itemCount: receipt.length,
                  itemBuilder: (context, index) {
                    return ReceiptItem(
                      receipt: receipt[index],
                      onDelete: () {
                        DialogService.showConfirmationDialog(
                          context: context,
                          title: DELETE_RECEIPT,
                          message: deleteReceiptMessage(receipt[index].name!),
                          onConfirm: () {
                            context.pop();
                          },
                          confirmText: DELETE,
                          cancelText: CANCEL,
                        );
                      },
                    );
                  },
                  separatorBuilder: (context, index) {
                    return const Divider(height: 30);
                  },
                )
                : const EmptyScreen(),
      ),
      floatingActionButton: BlocBuilder<FabCubit, bool>(
        builder: (context, state) {
          return Column(
            mainAxisAlignment: MainAxisAlignment.end,
            children: [
              Visibility(
                visible: state,
                child: Column(
                  children: [
                    // First FAB Button (bottom right)
                    FloatingActionButton(
                      heroTag: "create_receipt_fab",
                      onPressed: () {
                        context.pushNamed(ReceiptFormScreen.receiptForm, extra: ReceiptFormScreenArguments(isNew: true));
                      },
                      backgroundColor: Theme.of(context).colorScheme.primaryContainer,
                      child: Icon(Icons.add),
                    ),

                    SizedBox(height: 10),

                    // Second FAB Button (slightly above the first one)
                    FloatingActionButton(
                      heroTag: "scan_receipt_fab",
                      onPressed: () {
                        // Action for Button 2
                      },
                      backgroundColor: Theme.of(context).colorScheme.primaryContainer,
                      child: Icon(Icons.document_scanner_outlined),
                    ),
                    SizedBox(height: 10),
                  ],
                ),
              ),

              // Main Floating Action Button
              FloatingActionButton(
                heroTag: "main_fab",
                onPressed: () {
                  context.read<FabCubit>().toggle(); // Toggle the state of the FABs
                },
                backgroundColor: state ? Theme.of(context).colorScheme.inversePrimary : Theme.of(context).colorScheme.primaryContainer,
                child: Icon(state ? Icons.close : Icons.arrow_upward_outlined),
              ),
            ],
          );
        },
      ),
    );
  }
}
