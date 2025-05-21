import 'package:flutter/material.dart';
import 'package:receipt_splitter/common/empty_screen.dart';
import 'package:receipt_splitter/constants/strings.dart';
import 'package:receipt_splitter/model/menu_item.dart';
import 'package:receipt_splitter/model/participant.dart';
import 'package:receipt_splitter/module/receipt_detail/common/participant_list_view.dart';
import 'package:receipt_splitter/module/receipt_detail/common/table_widget.dart';

class ParticipantsItemWidget extends StatelessWidget {
  final List<Participant> participants;
  final List<MenuItem> items;
  final TabController tabController;
  final Function(Participant participant) onUpdateParticipant;
  final Function(MenuItem item) onUpdateItem;

  const ParticipantsItemWidget({super.key, required this.participants, required this.items, required this.tabController, required this.onUpdateParticipant, required this.onUpdateItem});

  @override
  Widget build(BuildContext context) {
    return Column(
      mainAxisSize: MainAxisSize.min,
      children: [
        TabBar(controller: tabController, tabs: const [Tab(icon: Icon(Icons.people_alt_outlined), text: "Participants"), Tab(icon: Icon(Icons.list_alt_outlined), text: "Items")]),
        Expanded(child: TabBarView(controller: tabController, children: [_buildParticipantsListView(List.of(participants), "Participants"), _buildListView(List.of(items), "Items")])),
      ],
    );
  }

  Widget _buildListView(List<MenuItem> list, String tab) {
    if (list.isEmpty) {
      return EmptyScreen(title: NO_ITEMS);
    } else {
      return Column(
        children: [
          SizedBox(height: 10),
          Expanded(
            child: TableWidget(
              items: list,
              actionName: ACTION,
              actionWidget: (index) => Align(alignment: Alignment.centerRight, child: IconButton(icon: const Icon(Icons.edit), onPressed: () => onUpdateItem(list[index]))),
            ),
          ),
        ],
      );
    }
  }

  Widget _buildParticipantsListView(List<Participant> participants, String tab) {
    if (participants.isEmpty) {
      return EmptyScreen(title: NO_PARTICIPANTS);
    } else {
      return ParticipantListView(participants: participants, icon: const Icon(Icons.edit), action: (index) => onUpdateParticipant(participants[index]), physics: const AlwaysScrollableScrollPhysics());
    }
  }
}
