import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:receipt_splitter/constants/strings.dart';
import 'package:receipt_splitter/model/receipt.dart';
import 'package:receipt_splitter/module/receipt_detail/screen/receipt_form_screen.dart';

import '../../../common/layout_builder_widget.dart';
import '../../../model/participant.dart';
import '../common/participant_card.dart';
import '../common/participant_stack_widget.dart';
import '../common/table_widget.dart';

class ItemsAndPeopleScreen extends StatelessWidget {
  final Receipt receipt;
  const ItemsAndPeopleScreen({super.key, required this.receipt});
  static const String itemsAndPeople = '/itemsAndPeople';

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('The Radio Bar'),
        centerTitle: true,
        actions: [
          IconButton(
            icon: const Icon(Icons.edit_outlined),
            onPressed: () {
              context.pushNamed(ReceiptFormScreen.receiptForm, extra: ReceiptFormScreenArguments(receipt: receipt, isNew: false));
            },
          ),
        ],
      ),
      body: LayoutBuilderWidget(
        child: Column(
          children: [
            Expanded(child: TableWidget(items: receipt.items, actionName: PEOPLE, actionWidget: (val) => ParticipantStackWidget(menuItem: receipt.items[val]))),
            const Divider(),
            SingleChildScrollView(
              padding: const EdgeInsets.only(top: 15.0),
              scrollDirection: Axis.horizontal,
              child: IntrinsicHeight(
                child: Row(
                  children: [
                    DraggableCard(participant: Participant(id: 0, name: ALL)),
                    VerticalDivider(width: 30, thickness: 1, indent: 10, endIndent: 10, color: Theme.of(context).colorScheme.outlineVariant),
                    ...receipt.participants.map((participant) {
                      return Row(children: [DraggableCard(participant: participant), SizedBox(width: 15)]);
                    }),
                  ],
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
