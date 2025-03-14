import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:receipt_splitter/constants/strings.dart';
import 'package:receipt_splitter/model/receipt.dart';
import 'package:receipt_splitter/module/receipt_list/common/receipt_item.dart';
import 'package:receipt_splitter/module/receipt_list/cubit/fab_cubit.dart';

class ReceiptListScreen extends StatelessWidget {
  ReceiptListScreen({super.key});

  static const String receiptSplit = '/receipt-split';

  final List<Receipt> receipt = [Receipt(id: 1, name: 'The Radio Bar', date: DateTime(2025, 3, 7)), Receipt(id: 2, name: 'The Lord', date: DateTime(2024, 12, 8))];

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text(RECEIPT_SPLITTER)),
      body: Padding(
        padding: EdgeInsets.symmetric(horizontal: 20),
        child: ListView.separated(
          itemCount: receipt.length,
          itemBuilder: (context, index) {
            return Column(children: [ReceiptItem(receipt: receipt[index], onDelete: () {}), const SizedBox(height: 8)]);
          },
          separatorBuilder: (context, index) {
            return const Divider();
          },
        ),
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
                        // Action for Button 1
                      },
                      backgroundColor: Colors.blue,
                      child: Icon(Icons.add),
                    ),

                    SizedBox(height: 10),

                    // Second FAB Button (slightly above the first one)
                    FloatingActionButton(
                      onPressed: () {
                        // Action for Button 2
                      },
                      backgroundColor: Colors.green,
                      child: Icon(Icons.edit),
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
                child: Icon(state ? Icons.close : Icons.arrow_upward_outlined),
              ),
            ],
          );
        },
      ),
    );
  }
}
