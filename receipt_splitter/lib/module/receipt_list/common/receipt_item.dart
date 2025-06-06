import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:go_router/go_router.dart';
import 'package:receipt_splitter/model/receipt.dart';
import 'package:receipt_splitter/module/receipt_detail/screen/items_and_people_screen.dart';
import 'package:receipt_splitter/module/receipt_list/cubit/receipt_list_cubit/receipt_list_cubit.dart';

import '../../../util/date_time_util.dart';

class ReceiptItem extends StatelessWidget {
  const ReceiptItem({super.key, required this.receipt, required this.onDelete});

  final Receipt receipt;
  final Function() onDelete;

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      behavior: HitTestBehavior.opaque,
      onTap: () {
        context.pushNamed(ItemsAndPeopleScreen.itemsAndPeople, extra: receipt).then((value) {
          if (context.mounted) {
            context.read<ReceiptListCubit>().loadReceipts();
          }
        });
      },
      child: Row(
        children: [
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  receipt.name!,
                  style: Theme.of(context).textTheme.bodyLarge?.copyWith(
                    color: Theme.of(context).colorScheme.onSurface,
                  ),
                ),
                SizedBox(height: 8),
                Text(
                  DateTimeUtil.dayMonthYear(receipt.date!),
                  style: Theme.of(context).textTheme.bodyMedium?.copyWith(
                    color: Theme.of(context).colorScheme.onSurfaceVariant,
                  ),
                ),
              ],
            ),
          ),
          IconButton(icon: const Icon(Icons.delete), onPressed: onDelete),
        ],
      ),
    );
  }
}
