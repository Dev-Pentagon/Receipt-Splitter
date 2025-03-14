import 'package:flutter/material.dart';
import 'package:receipt_splitter/model/receipt.dart';
import 'package:receipt_splitter/services/date_time_service.dart';

class ReceiptItem extends StatelessWidget {
  const ReceiptItem({super.key, required this.receipt, required this.onDelete});

  final Receipt receipt;
  final Function() onDelete;

  @override
  Widget build(BuildContext context) {
    return Row(
      children: [
        Expanded(child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(receipt.name),
            SizedBox(height: 8,),
            Text(DateTimeService.dayMonthYear(receipt.date)),
          ],
        )),
        IconButton(
          icon: const Icon(Icons.delete),
          onPressed: onDelete,
        ),
      ],
    );
  }
}
