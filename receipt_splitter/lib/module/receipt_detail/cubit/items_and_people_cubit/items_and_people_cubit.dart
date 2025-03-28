import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:receipt_splitter/model/menu_item.dart';
import 'package:receipt_splitter/model/participant.dart';

part 'items_and_people_state.dart';

class ItemsAndPeopleCubit extends Cubit<ItemsAndPeopleState> {
  ItemsAndPeopleCubit() : super(ItemsAndPeopleInitial());

  void linkParticipantToItem({
    required List<MenuItem> items,
    required List<Participant> participants,
    required Participant participant,
    required String itemId,
  }) {
    final item = items.firstWhere((item) => item.uid == itemId);
    if (participant.uid == 'PRT0') {
      // add all participants to the item, should not be duplicated.
      for (Participant p in participants) {
        if (item.participants.where((i) => i.uid == p.uid).isEmpty) {
          item.participants.add(p);
        }
      }
    } else {
      if (item.participants.where((p) => p.uid == participant.uid).isEmpty) {
        item.participants.add(participant);
        emit(ItemsAndPeopleUpdated(items: items, fromDelete: false));
      } else {
        emit(AlreadyLinked());
      }
    }
  }

  void removeParticipant({
    required List<MenuItem> items,
    required String itemId,
    required Participant participant,
  }) {
    final item = items.firstWhere((item) => item.uid == itemId);
    item.participants.removeWhere((p) => p.uid == participant.uid);
    emit(ItemsAndPeopleUpdated(items: items, fromDelete: true));
  }
}
