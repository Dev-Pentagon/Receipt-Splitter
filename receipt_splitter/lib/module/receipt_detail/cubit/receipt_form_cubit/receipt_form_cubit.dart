import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import '../../../../config/app_config.dart';
import '../../../../model/menu_item.dart';
import '../../../../model/participant.dart';
import '../../../../model/receipt.dart';
import '../../../../repository/receipt_repository.dart';
import '../../../../util/id_generator_util.dart';

part 'receipt_form_state.dart';

class ReceiptFormCubit extends Cubit<ReceiptFormState> {
  final ReceiptRepository repository;

  ReceiptFormCubit(this.repository) : super(ReceiptFormInitial());

  void setForm(Receipt receipt) {
    emit(ReceiptFormLoaded(receipt: receipt));
  }

  void saveForm(Receipt receipt) async {
    try {
      final String id = await IdGeneratorUtil.generateId(IdentifierType.receipt);
      receipt.uid = id;

      bool res = await repository.createReceipt(receipt);

      if (res) {
        emit(ReceiptFormSaved(receipt: receipt));
      } else {
        emit(ReceiptFormSaveFailed(message: 'Failed to save receipt!'));
      }
    } catch (e) {
      emit(ReceiptFormSaveFailed(message: 'Failed to save receipt: $e'));
    }
  }

  void updateForm(Receipt receipt) async {
    try {
      bool res = await repository.updateReceipt(receipt);

      if (res) {
        emit(ReceiptFormUpdated(receipt: receipt));
      } else {
        emit(ReceiptFormSaveFailed(message: 'Failed to update receipt!'));
      }
    } catch (e) {
      emit(ReceiptFormSaveFailed(message: 'Failed to update receipt: $e'));
    }
  }

  void deleteForm(String receiptId) async {
    try {
      bool res = await repository.deleteReceipt(receiptId);

      if (res) {
        emit(ReceiptDeletedSuccessfully());
      } else {
        emit(ReceiptDeletedFailed(message: 'Failed to delete receipt!'));
      }
    } catch (e) {
      emit(ReceiptDeletedFailed(message: 'Failed to delete receipt: $e'));
    }
  }

  void updateParticipant({required List<Participant> participants, required Participant participant, required String receiptId}) async {
    try {
      bool exists = participants.any((p) => p.uid == participant.uid);
      bool res = exists ? await repository.updateParticipant(participant) : await repository.addParticipant(participant, receiptId);

      if (res) {
        List<Participant> newParticipants = updateItemById<Participant>(List.of(participants), participant, (p) => p.uid);
        emit(ParticipantUpdated(participants: newParticipants));
      } else {
        emit(ReceiptFormSaveFailed(message: exists ? 'Failed to update participant!' : 'Failed to create participant!'));
      }
    } catch (e) {
      emit(ReceiptFormSaveFailed(message: 'Failed to ${participants.any((p) => p.uid == participant.uid) ? 'update' : 'create'} participant: $e'));
    }
  }

  void deleteParticipant({required List<Participant> participants, required Participant participant}) async {
    try {
      bool res = await repository.deleteParticipant(participant.uid);

      if (res) {
        List<Participant> newParticipants = List.from(participants)..removeWhere((p) => p.uid == participant.uid);
        emit(ParticipantUpdated(participants: newParticipants));
      } else {
        emit(ReceiptFormSaveFailed(message: 'Failed to delete participant!'));
      }
    } catch (e) {
      emit(ReceiptFormSaveFailed(message: 'Failed to delete participant: $e'));
    }
  }

  void updateItem({required List<MenuItem> items, required MenuItem item, required String receiptId}) async {
    try {
      bool exists = items.any((i) => i.uid == item.uid);
      bool res = exists ? await repository.updateItem(item, receiptId) : await repository.addItem(item, receiptId);

      if (res) {
        List<MenuItem> newItems = updateItemById<MenuItem>(List.of(items), item, (i) => i.uid);
        emit(MenuItemUpdated(items: newItems));
      } else {
        emit(ReceiptFormSaveFailed(message: exists ? 'Failed to update item!' : 'Failed to create item!'));
      }
    } catch (e) {
      emit(ReceiptFormSaveFailed(message: 'Failed to ${items.any((i) => i.uid == item.uid) ? 'update' : 'create'} item: $e'));
    }
  }

  void deleteItem({required List<MenuItem> items, required MenuItem item}) async {
    try {
      bool res = await repository.deleteItem(item.uid);

      if (res) {
        List<MenuItem> newItems = List.from(items)..removeWhere((i) => i.uid == item.uid);
        emit(MenuItemUpdated(items: newItems));
      } else {
        emit(ReceiptFormSaveFailed(message: 'Failed to delete item!'));
      }
    } catch (e) {
      emit(ReceiptFormSaveFailed(message: 'Failed to delete item: $e'));
    }
  }

  void resetForm() {
    emit(ReceiptFormInitial());
  }

  /// Updates an element in [list] by matching its id.
  /// [updatedItem] is the new item that should replace the matching one.
  /// [idGetter] is a function that extracts the id from an item.
  List<T> updateItemById<T>(List<T> list, T updatedItem, dynamic Function(T) idGetter) {
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
