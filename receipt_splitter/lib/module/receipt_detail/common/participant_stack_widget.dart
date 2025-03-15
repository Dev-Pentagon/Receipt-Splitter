import 'package:flutter/material.dart';
import 'package:receipt_splitter/model/menu_item.dart';
import 'package:receipt_splitter/model/participant.dart';
import 'package:receipt_splitter/module/receipt_detail/common/participant_avatar.dart';
import 'package:receipt_splitter/module/receipt_detail/common/participant_list_view.dart';
import 'package:receipt_splitter/services/dialog_service.dart';

class ParticipantStackWidget extends StatelessWidget {
  final MenuItem menuItem;
  const ParticipantStackWidget({super.key, required this.menuItem});

  // Offset between each circle
  final double offset = 15.0;

  @override
  Widget build(BuildContext context) {
    // Return nothing if no participants
    if (menuItem.participants.isEmpty) {
      return const SizedBox.shrink();
    }

    return Align(
      alignment: Alignment.centerRight,
      child: GestureDetector(
        onTap: () {
          DialogService.customDialog(context, ParticipantOfItemDialog(item: menuItem));
        },
        child: _buildParticipantStack(context),
      ),
    );
  }

  Widget _buildParticipantStack(BuildContext context) {
    List<Participant> participants = menuItem.participants;
    // If 3 or fewer participants, just show them all
    if (participants.length <= 3) {
      return SizedBox(
        // Set width to account for overlapping (last item position + width)
        width: offset * (participants.length - 1) + 25,
        height: 25,
        child: Stack(
          children:
              participants.asMap().entries.map((entry) {
                final index = entry.key;
                final person = entry.value;
                return Positioned(
                  left: offset * index,
                  child: ParticipantAvatar(
                    participant: person,
                    height: 25,
                    width: 25,
                    textStyle: Theme.of(context).textTheme.labelSmall?.copyWith(color: Theme.of(context).colorScheme.onPrimaryContainer),
                    backgroundColor: Theme.of(context).colorScheme.primaryContainer,
                    border: Border.all(color: Theme.of(context).colorScheme.scrim),
                  ),
                );
              }).toList(),
        ),
      );
    } else {
      // More than 3: show first two + a circle with the remaining count
      final firstTwo = participants.take(2).toList();
      final remainingCount = participants.length - 2;

      return SizedBox(
        width: offset * 2 + 25,
        height: 25,
        child: Stack(
          children: [
            // First participant at offset 0
            Positioned(
              left: 0,
              child: ParticipantAvatar(
                participant: firstTwo[0],
                height: 25,
                width: 25,
                textStyle: Theme.of(context).textTheme.labelSmall?.copyWith(color: Theme.of(context).colorScheme.onPrimaryContainer),
                backgroundColor: Theme.of(context).colorScheme.primaryContainer,
                border: Border.all(color: Theme.of(context).colorScheme.scrim),
              ),
            ),
            // Second participant at offset
            Positioned(
              left: offset,
              child: ParticipantAvatar(
                participant: firstTwo[1],
                height: 25,
                width: 25,
                textStyle: Theme.of(context).textTheme.labelSmall?.copyWith(color: Theme.of(context).colorScheme.onPrimaryContainer),
                backgroundColor: Theme.of(context).colorScheme.primaryContainer,
                border: Border.all(color: Theme.of(context).colorScheme.scrim),
              ),
            ),
            // +N circle at next offset
            Positioned(
              left: offset * 2,
              child: Container(
                width: 25,
                height: 25,
                alignment: Alignment.center,
                decoration: BoxDecoration(shape: BoxShape.circle, color: Theme.of(context).colorScheme.onInverseSurface, border: Border.all(color: Theme.of(context).colorScheme.scrim)),
                child: Text('+$remainingCount', style: Theme.of(context).textTheme.labelSmall?.copyWith(color: Theme.of(context).colorScheme.onPrimaryContainer)),
              ),
            ),
          ],
        ),
      );
    }
  }
}

class ParticipantOfItemDialog extends StatelessWidget {
  final MenuItem item;
  const ParticipantOfItemDialog({super.key, required this.item});

  @override
  Widget build(BuildContext context) {
    return AlertDialog(
      title: Text(item.name),
      content: SizedBox(
        width: double.maxFinite,
        height: 250,
        child: Scrollbar(thumbVisibility: true, child: ParticipantListView(participants: item.participants, icon: Icon(Icons.delete_outline), action: () {}, physics: AlwaysScrollableScrollPhysics())),
      ),
      actions: [TextButton(onPressed: () => Navigator.pop(context), child: const Text('Close'))],
    );
  }
}
