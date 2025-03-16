import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:receipt_splitter/model/participant.dart';

import '../../../../model/menu_item.dart';
import '../../../../model/receipt.dart';

part 'receipt_form_state.dart';

class ReceiptFormCubit extends Cubit<ReceiptFormState> {
  ReceiptFormCubit() : super(ReceiptFormInitial());

  void saveForm(Receipt receipt) {
    // TODO: Implement save form logic to Database
    emit(ReceiptFormSaved(receipt: receipt));
  }

  void updateForm(Receipt receipt) {
    // TODO: Implement update form logic to Database
    emit(ReceiptFormUpdated(receipt: receipt));
  }

  void updateParticipant({required List<Participant> participants, required Participant participant}) {
    List<Participant> newParticipants = _updateList<Participant>(participants, participant);

    emit(ParticipantUpdated(participants: newParticipants));
  }

  void updateItem({required List<MenuItem> items, required MenuItem item}) {
    List<MenuItem> newItems = _updateList<MenuItem>(items, item);

    emit(MenuItemUpdated(items: newItems));
  }

  void resetForm() {
    emit(ReceiptFormInitial());
  }

  List<T> _updateList<T>(List<T> list, T item) {
    if (list.contains(item)) {
      list[list.indexOf(item)] = item;
    } else {
      list.add(item);
    }
    return list;
  }
}
