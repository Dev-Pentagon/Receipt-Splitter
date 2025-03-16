import 'package:flutter/material.dart';
import 'package:receipt_splitter/model/participant.dart';
import 'package:receipt_splitter/module/receipt_detail/common/participant_avatar.dart';

class DraggableCard extends StatelessWidget {
  final Participant participant;
  const DraggableCard({super.key, required this.participant});

  @override
  Widget build(BuildContext context) {
    return LongPressDraggable<Participant>(
      data: participant,
      delay: Duration(milliseconds: 200),
      feedback: Stack(
        clipBehavior: Clip.none,
        children: [
          _ParticipantCard(participant: participant),
          Positioned(
            right: -5,
            top: -5,
            child: Container(
              decoration: BoxDecoration(color: Theme.of(context).colorScheme.primary, borderRadius: BorderRadius.circular(20)),
              child: Icon(Icons.add_circle_outline, color: Theme.of(context).colorScheme.onPrimary, size: 20),
            ),
          ),
        ],
      ),
      childWhenDragging: _ParticipantCard(participant: participant, opacity: 0.75),
      child: _ParticipantCard(participant: participant),
    );
  }
}

class _ParticipantCard extends StatelessWidget {
  final Participant participant;
  final double opacity;
  const _ParticipantCard({required this.participant, this.opacity = 1});

  @override
  Widget build(BuildContext context) {
    return Opacity(
      opacity: opacity,
      child: Container(
        width: 100,
        height: 120,
        decoration: BoxDecoration(color: Theme.of(context).colorScheme.surfaceContainerHigh, borderRadius: BorderRadius.circular(20)),
        padding: const EdgeInsets.symmetric(horizontal: 12.5, vertical: 8.5),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            ParticipantAvatar(participant: participant),
            const SizedBox(height: 6),
            Text(participant.name, style: Theme.of(context).textTheme.titleSmall?.copyWith(color: Theme.of(context).colorScheme.onSurface, overflow: TextOverflow.ellipsis)),
          ],
        ),
      ),
    );
  }
}
