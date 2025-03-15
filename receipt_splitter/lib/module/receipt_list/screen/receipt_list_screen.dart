import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:go_router/go_router.dart';
import 'package:receipt_splitter/common/empty_screen.dart';
import 'package:receipt_splitter/common/layout_builder_widget.dart';
import 'package:receipt_splitter/constants/strings.dart';
import 'package:receipt_splitter/model/receipt.dart';
import 'package:receipt_splitter/module/receipt_list/common/receipt_item.dart';
import 'package:receipt_splitter/module/receipt_list/cubit/fab_cubit.dart';
import 'package:receipt_splitter/services/dialog_service.dart';

class ReceiptListScreen extends StatelessWidget {
  ReceiptListScreen({super.key});

  static const String receiptSplit = '/receiptSplit';

  final List<Receipt> receipt = [Receipt(id: 1, name: 'The Radio Bar', date: DateTime(2025, 3, 7)), Receipt(id: 2, name: 'The Lord', date: DateTime(2024, 12, 8))];
  final List<Receipt> receipt2 = [];

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
            receipt2.isNotEmpty
                ? ListView.separated(
                  itemCount: receipt.length,
                  itemBuilder: (context, index) {
                    return Column(children: [ReceiptItem(receipt: receipt[index], onDelete: () {}), const SizedBox(height: 8)]);
                  },
                  separatorBuilder: (context, index) {
                    return const Divider();
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
                      onPressed: () {
                        // testing purpose
                        DialogService.showConfirmationDialog(
                          context: context,
                          title: DELETE_RECEIPT,
                          message: deleteReceiptMessage('The Radio Bar'),
                          onConfirm: () {
                            context.pop();
                          },
                        );
                      },
                      backgroundColor: Theme.of(context).colorScheme.primaryContainer,
                      child: Icon(Icons.add),
                    ),

                    SizedBox(height: 10),

                    // Second FAB Button (slightly above the first one)
                    FloatingActionButton(
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
