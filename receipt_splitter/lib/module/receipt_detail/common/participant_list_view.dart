import 'package:flutter/material.dart';
import 'package:receipt_splitter/module/receipt_detail/common/participant_avatar.dart';

import '../../../model/participant.dart';

class ParticipantListView extends StatelessWidget {
  final List<Participant> participants;
  final ScrollPhysics? physics;
  final Widget icon;
  final Function action;
  const ParticipantListView({super.key, required this.participants, required this.icon, required this.action, this.physics});

  @override
  Widget build(BuildContext context) {
    return ListView.separated(
      shrinkWrap: true,
      physics: physics,
      itemBuilder:
          (context, index) => Row(
            children: [
              ParticipantAvatar(participant: participants[index], width: 40, height: 40),
              SizedBox(width: 16),
              Text(participants[index].name, style: Theme.of(context).textTheme.bodyLarge),
              Spacer(),
              IconButton(
                icon: icon,
                onPressed: () {
                  action();
                },
              ),
            ],
          ),
      separatorBuilder: (context, index) => Divider(),
      itemCount: participants.length,
    );
  }
}
