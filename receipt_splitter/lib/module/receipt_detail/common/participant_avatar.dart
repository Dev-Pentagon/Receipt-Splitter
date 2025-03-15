import 'package:flutter/material.dart';
import 'package:receipt_splitter/constants/strings.dart';
import 'package:receipt_splitter/extension/string_extension.dart';
import 'package:receipt_splitter/model/participant.dart';

class ParticipantAvatar extends StatelessWidget {
  const ParticipantAvatar({
    super.key,
    required this.participant,  this.width = 75,  this.height = 75, this.radius = 24
  });

  final Participant participant;
  final double width;
  final double height;
  final double radius;

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      height: height,
      width: width,
      child: CircleAvatar(
        radius: radius,
        backgroundColor: Theme.of(context).colorScheme.tertiary,
        child:
        participant.name == ALL
            ? const Icon(Icons.group, color: Colors.white)
            : Text(participant.name.getInitials(), style: Theme.of(context).textTheme.titleMedium?.copyWith(color: Theme.of(context).colorScheme.onTertiary)),
      ),
    );
  }
}