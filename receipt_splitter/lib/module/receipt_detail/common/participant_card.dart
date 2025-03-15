import 'package:flutter/material.dart';
import 'package:receipt_splitter/extension/string_extension.dart';
import 'package:receipt_splitter/model/participant.dart';

import '../../../constants/strings.dart';

class ParticipantCard extends StatelessWidget {
  final Participant participant;
  const ParticipantCard({super.key, required this.participant});

  @override
  Widget build(BuildContext context) {
    return Container(
      width: 100,
      height: 120,
      decoration: BoxDecoration(color: Theme.of(context).colorScheme.surfaceContainerHigh, borderRadius: BorderRadius.circular(20)),
      padding: const EdgeInsets.symmetric(horizontal: 12.5, vertical: 8.5),
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          SizedBox(
            height: 75,
            width: 75,
            child: CircleAvatar(
              radius: 24,
              backgroundColor: Theme.of(context).colorScheme.tertiary,
              child:
                  participant.name == ALL
                      ? const Icon(Icons.group, color: Colors.white)
                      : Text(participant.name.getInitials(), style: Theme.of(context).textTheme.titleMedium?.copyWith(color: Theme.of(context).colorScheme.onTertiary)),
            ),
          ),
          const SizedBox(height: 6),
          Text(participant.name, style: Theme.of(context).textTheme.titleSmall?.copyWith(color: Theme.of(context).colorScheme.onSurface, overflow: TextOverflow.ellipsis)),
        ],
      ),
    );
  }
}
