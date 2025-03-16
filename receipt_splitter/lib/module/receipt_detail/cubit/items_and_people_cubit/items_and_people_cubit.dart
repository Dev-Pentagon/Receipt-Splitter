import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:receipt_splitter/model/menu_item.dart';
import 'package:receipt_splitter/model/participant.dart';

part 'items_and_people_state.dart';

class ItemsAndPeopleCubit extends Cubit<ItemsAndPeopleState> {
  ItemsAndPeopleCubit() : super(ItemsAndPeopleInitial());

  void linkParticipantToItem({required List<MenuItem> items, required Participant participant, required String itemId}) {
    final item = items.firstWhere((item) => item.id == itemId);
    if (item.participants.where((p) => p.id == participant.id).isEmpty) {
      item.participants.add(participant);
      emit(ItemsAndPeopleUpdated(items: items));
    } else {
      emit(AlreadyLinked());
    }
  }
}
