import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:receipt_splitter/model/participant.dart';

import '../../../../config/app_config.dart';
import '../../../../model/menu_item.dart';
import '../../../../model/receipt.dart';
import '../../../../util/id_generator_util.dart';

part 'receipt_form_state.dart';

class ReceiptFormCubit extends Cubit<ReceiptFormState> {
  ReceiptFormCubit() : super(ReceiptFormInitial());

  void setForm(Receipt receipt) {
    emit(ReceiptFormLoaded(receipt: receipt));
  }

  void saveForm(Receipt receipt) async {
    final String id = await IdGeneratorUtil.generateId(IdentifierType.receipt);
    receipt.uid = id;
    // TODO: Implement save form logic to Database
    emit(ReceiptFormSaved(receipt: receipt));
  }

  void updateForm(Receipt receipt) {
    // TODO: Implement update form logic to Database
    emit(ReceiptFormUpdated(receipt: receipt));
  }

  void updateParticipant({
    required List<Participant> participants,
    required Participant participant,
  }) {
    List<Participant> newParticipants = updateItemById<Participant>(
      List.of(participants),
      participant,
      (p) => p.uid,
    );

    emit(ParticipantUpdated(participants: newParticipants));
  }

  void updateItem({required List<MenuItem> items, required MenuItem item}) {
    List<MenuItem> newItems = updateItemById<MenuItem>(
      List.of(items),
      item,
      (i) => i.uid,
    );

    emit(MenuItemUpdated(items: newItems));
  }

  void deleteParticipant({
    required List<Participant> participants,
    required Participant participant,
  }) {
    List<Participant> newParticipants = List.from(participants);
    newParticipants.removeWhere((p) => p.uid == participant.uid);

    emit(ParticipantUpdated(participants: newParticipants));
  }

  void deleteItem({required List<MenuItem> items, required MenuItem item}) {
    List<MenuItem> newItems = List.from(items);
    newItems.removeWhere((i) => i.uid == item.uid);

    emit(MenuItemUpdated(items: newItems));
  }

  void resetForm() {
    emit(ReceiptFormInitial());
  }

  /// Updates an element in [list] by matching its id.
  /// [updatedItem] is the new item that should replace the matching one.
  /// [idGetter] is a function that extracts the id from an item.
  List<T> updateItemById<T>(
    List<T> list,
    T updatedItem,
    dynamic Function(T) idGetter,
  ) {
    final updatedId = idGetter(updatedItem);
    final index = list.indexWhere((item) => idGetter(item) == updatedId);
    if (index != -1) {
      list[index] = updatedItem;
    } else {
      list.add(updatedItem);
    }

    return list;
  }
}
