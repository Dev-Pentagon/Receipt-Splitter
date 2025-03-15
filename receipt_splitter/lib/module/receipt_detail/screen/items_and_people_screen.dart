import 'package:flutter/material.dart';
import 'package:receipt_splitter/constants/strings.dart';
import 'package:receipt_splitter/model/menu_item.dart';
import 'package:receipt_splitter/model/receipt.dart';

import '../../../common/layout_builder_widget.dart';
import '../../../model/participant.dart';
import '../common/participant_card.dart';
import '../common/table_widget.dart';

class ItemsAndPeopleScreen extends StatelessWidget {
  ItemsAndPeopleScreen({super.key});
  static const String itemsAndPeople = '/itemsAndPeople';

  final Receipt receipt = Receipt(id: 1, name: 'The Radio Bar', date: DateTime.now());
  final List<MenuItem> items = [
    MenuItem(id: 1, name: 'Margarita', quantity: 1, price: 10.0),
    MenuItem(id: 2, name: 'Mojito', quantity: 2, price: 20.0),
    MenuItem(id: 3, name: 'Old Fashioned', quantity: 1, price: 15.0),
  ];

  final List<Participant> participants = [
    Participant(id: 1, name: 'Wunna Kyaw'),
    Participant(id: 2, name: 'Kayy'),
    Participant(id: 3, name: 'Kyaw Lwin Soe'),
    Participant(id: 4, name: 'Nyein Chan Moe'),
    Participant(id: 5, name: 'Wai Yan Kyaw'),
    Participant(id: 6, name: 'Ye Thurein Kyaw'),
  ];

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('The Radio Bar'), actions: [IconButton(icon: const Icon(Icons.edit), onPressed: () {})]),
      body: LayoutBuilderWidget(
        child: Column(
          children: [
            Expanded(child: TableWidget(items: items, actionName: PEOPLE, actionWidget: (val) => const Icon(Icons.delete))),
            // ParticipantStackWidget(
            //   participants: participants,
            // ),
            const Divider(),
            SingleChildScrollView(
              padding: const EdgeInsets.only(top: 15.0),
              scrollDirection: Axis.horizontal,
              child: IntrinsicHeight(
                child: Row(
                  children: [
                    ParticipantCard(participant: Participant(id: 0, name: ALL)),
                    VerticalDivider(width: 30, thickness: 1, indent: 10, endIndent: 10, color: Theme.of(context).colorScheme.outlineVariant),
                    ...participants.map((participant) {
                      return Row(
                        children: [
                          ParticipantCard(participant: participant),
                          SizedBox(width: 15),
                        ],
                      );
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
