import 'package:flutter/material.dart';
import 'package:receipt_splitter/model/participant.dart';

class ParticipantStackWidget extends StatelessWidget {
  final List<Participant> participants;
  const ParticipantStackWidget({super.key, required this.participants});

  @override
  Widget build(BuildContext context) {
    return Stack(
      children: [
        ...participants.map((participant) {
          return Positioned(
            left: 0,
            child: ParticipantAvatar(name: participant.name),
          );
        }),
      ],
    );
  }
}

class ParticipantAvatar extends StatelessWidget {
  final String name;
  const ParticipantAvatar({super.key, required this.name});

  @override
  Widget build(BuildContext context) {
    return CircleAvatar(
      radius: 24,
      backgroundColor: Theme.of(context).colorScheme.primaryContainer,
      child: Text(
        name,
        style: Theme.of(context).textTheme.labelSmall?.copyWith(color: Theme.of(context).colorScheme.onPrimaryContainer),
      ),
    );
  }
}
