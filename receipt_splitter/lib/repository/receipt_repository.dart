import 'package:sqflite/sqflite.dart';

import '../model/menu_item.dart';
import '../model/participant.dart';
import '../model/receipt.dart';
import '../services/database_service.dart';

abstract class ReceiptRepository {
  Future<bool> createReceipt(Receipt receipt);
  Future<bool> addParticipant(Participant participant, String receiptId);
  Future<bool> addItem(MenuItem item, String receiptId);
  Future<List<Receipt>> getReceipts();
  Future<bool> updateReceipt(Receipt receipt);
  Future<bool> deleteReceipt(String receiptId);
  Future<bool> updateParticipant(Participant participant);
  Future<bool> deleteParticipant(String participantId);
  Future<bool> updateItem(MenuItem item, String receiptId);
  Future<bool> deleteItem(String itemId);
  Future<bool> linkItemParticipant(String itemId, String participantId);
  Future<bool> unlinkItemParticipant(String itemId, String participantId);
}

class ReceiptRepositoryImpl implements ReceiptRepository {
  final DatabaseService db;

  ReceiptRepositoryImpl(this.db);

  @override
  Future<bool> createReceipt(Receipt receipt) async {
    final result = await db.insert('receipts', receipt.toMap());
    return result > 0;
  }

  @override
  Future<bool> addParticipant(Participant participant, String receiptId) async {
    try {
      await db.transaction((txn) async {
        await txn.insert('participants', participant.toMap());
        await txn.insert('receipt_participants', {'receipt_id': receiptId, 'participant_id': participant.uid});
      });
      return true;
    } catch (_) {
      return false;
    }
  }

  @override
  Future<bool> addItem(MenuItem item, String receiptId) async {
    final result = await db.insert('items', item.toMap(receiptId));
    return result > 0;
  }

  @override
  Future<List<Receipt>> getReceipts() async {
    return await db.transaction((txn) async {
      final receiptMaps = await txn.query('receipts');

      List<Receipt> receipts = [];

      for (var receiptMap in receiptMaps) {
        final receiptId = receiptMap['id'] as String;

        // 1. Fetch participants linked to this receipt
        final participantIdsMaps = await txn.query('receipt_participants', columns: ['participant_id'], where: 'receipt_id = ?', whereArgs: [receiptId]);

        final participantIds = participantIdsMaps.map((e) => e['participant_id'] as String).toList();

        final participantMaps = await txn.query('participants', where: 'id IN (${List.filled(participantIds.length, '?').join(',')})', whereArgs: participantIds);

        final participants = participantMaps.map((e) => Participant.fromMap(e)).toList();

        // 2. Fetch items
        final itemMaps = await txn.query('items', where: 'receipt_id = ?', whereArgs: [receiptId]);

        List<MenuItem> items = [];

        for (var itemMap in itemMaps) {
          final itemId = itemMap['id'] as String;

          // Get participant IDs for this item
          final itemPartMaps = await txn.query('item_participants', columns: ['participant_id'], where: 'item_id = ?', whereArgs: [itemId]);

          final itemParticipantIds = itemPartMaps.map((e) => e['participant_id'] as String).toList();

          final itemParticipantMaps = await txn.query('participants', where: 'id IN (${List.filled(itemParticipantIds.length, '?').join(',')})', whereArgs: itemParticipantIds);

          final itemParticipants = itemParticipantMaps.map((e) => Participant.fromMap(e)).toList();

          final item = MenuItem.fromMap(itemMap, itemParticipants);
          items.add(item);
        }

        // 3. Create and add the receipt
        receipts.add(Receipt.fromMap(receiptMap, participants, items));
      }

      return receipts;
    });
  }

  @override
  Future<bool> updateReceipt(Receipt receipt) async {
    final result = await db.update('receipts', receipt.toMap(), where: 'id = ?', whereArgs: [receipt.uid]);
    return result > 0;
  }

  @override
  Future<bool> deleteReceipt(String receiptId) async {
    try {
      await db.transaction((txn) async {
        // 1. Get item IDs related to the receipt
        final itemRows = await txn.query('items', columns: ['id'], where: 'receipt_id = ?', whereArgs: [receiptId]);

        final itemIds = itemRows.map((e) => e['id'] as String).toList();

        // 2. Delete from item_participants
        for (var itemId in itemIds) {
          await txn.delete('item_participants', where: 'item_id = ?', whereArgs: [itemId]);
        }

        // 3. Delete items
        await txn.delete('items', where: 'receipt_id = ?', whereArgs: [receiptId]);

        // 4. Delete from receipt_participants
        await txn.delete('receipt_participants', where: 'receipt_id = ?', whereArgs: [receiptId]);

        // 5. Delete the receipt
        await txn.delete('receipts', where: 'id = ?', whereArgs: [receiptId]);
      });
      return true;
    } catch (e) {
      return false;
    }
  }

  @override
  Future<bool> updateParticipant(Participant participant) async {
    final result = await db.update('participants', participant.toMap(), where: 'id = ?', whereArgs: [participant.uid]);
    return result > 0;
  }

  @override
  Future<bool> deleteParticipant(String participantId) async {
    try {
      await db.transaction((txn) async {
        await txn.delete('receipt_participants', where: 'participant_id = ?', whereArgs: [participantId]);
        await txn.delete('item_participants', where: 'participant_id = ?', whereArgs: [participantId]);
        await txn.delete('participants', where: 'id = ?', whereArgs: [participantId]);
      });
      return true;
    } catch (_) {
      return false;
    }
  }

  @override
  Future<bool> updateItem(MenuItem item, String receiptId) async {
    final result = await db.update('items', item.toMap(receiptId), where: 'id = ?', whereArgs: [item.uid]);
    return result > 0;
  }

  @override
  Future<bool> deleteItem(String itemId) async {
    try {
      await db.transaction((txn) async {
        await txn.delete('item_participants', where: 'item_id = ?', whereArgs: [itemId]);
        await txn.delete('items', where: 'id = ?', whereArgs: [itemId]);
      });
      return true;
    } catch (e) {
      return false;
    }
  }

  @override
  Future<bool> linkItemParticipant(String itemId, String participantId) async {
    try {
      final result = await db.insert('item_participants', {'item_id': itemId, 'participant_id': participantId}, conflictAlgorithm: ConflictAlgorithm.ignore);
      return result != 0;
    } catch (e) {
      return false;
    }
  }

  @override
  Future<bool> unlinkItemParticipant(String itemId, String participantId) async {
    try {
      final result = await db.delete('item_participants', where: 'item_id = ? AND participant_id = ?', whereArgs: [itemId, participantId]);
      return result > 0;
    } catch (e) {
      return false;
    }
  }
}
