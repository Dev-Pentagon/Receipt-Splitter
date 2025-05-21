import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:receipt_splitter/model/menu_item.dart';
import 'package:receipt_splitter/model/participant.dart';
import 'package:receipt_splitter/repository/receipt_repository.dart';

part 'items_and_people_state.dart';

class ItemsAndPeopleCubit extends Cubit<ItemsAndPeopleState> {
  final ReceiptRepository repository;
  ItemsAndPeopleCubit(this.repository) : super(ItemsAndPeopleInitial());

  void linkParticipantToItem({required List<MenuItem> items, required List<Participant> participants, required Participant participant, required String itemId}) async {
    try {
      final item = items.firstWhere((item) => item.uid == itemId);

      if (participant.uid == 'PRT0') {
        bool allLinked = true;
        for (Participant p in participants) {
          final alreadyLinked = item.participants.any((i) => i.uid == p.uid);
          if (!alreadyLinked) {
            final res = await repository.linkItemParticipant(itemId, p.uid);
            if (res) {
              item.participants.add(p);
            } else {
              allLinked = false;
            }
          }
        }
        emit(allLinked ? ItemsAndPeopleUpdated(items: items, fromDelete: false) : ItemsAndPeopleFailed(message: 'Some participants failed to link.'));
      } else {
        final alreadyLinked = item.participants.any((p) => p.uid == participant.uid);
        if (!alreadyLinked) {
          final res = await repository.linkItemParticipant(itemId, participant.uid);
          if (res) {
            item.participants.add(participant);
            emit(ItemsAndPeopleUpdated(items: items, fromDelete: false));
          } else {
            emit(ItemsAndPeopleFailed(message: 'Failed to link participant!'));
          }
        } else {
          emit(AlreadyLinked());
        }
      }
    } catch (e) {
      emit(ItemsAndPeopleFailed(message: 'Error linking participant: $e'));
    }
  }

  void removeParticipantFromItem({required List<MenuItem> items, required String itemId, required Participant participant}) async {
    try {
      final item = items.firstWhere((item) => item.uid == itemId);
      final res = await repository.unlinkItemParticipant(itemId, participant.uid);
      if (res) {
        item.participants.removeWhere((p) => p.uid == participant.uid);
        emit(ItemsAndPeopleUpdated(items: items, fromDelete: true));
      } else {
        emit(ItemsAndPeopleFailed(message: 'Failed to unlink participant!'));
      }
    } catch (e) {
      emit(ItemsAndPeopleFailed(message: 'Error unlinking participant: $e'));
    }
  }
}
