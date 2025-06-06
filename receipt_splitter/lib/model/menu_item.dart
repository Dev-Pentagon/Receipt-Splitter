import '../config/app_config.dart';
import '../util/id_generator_util.dart';
import 'participant.dart';

class MenuItem {
  final String uid;
  final String name;
  final int quantity;
  final double price;
  final double total;
  final List<Participant> participants;

  // Private constructor for internal use
  MenuItem._({
    required this.uid,
    required this.name,
    required this.quantity,
    required this.price,
  }) : total = price * quantity,
       participants = [];

  // Standard constructor (requires id)
  MenuItem({
    required this.uid,
    required this.name,
    required this.quantity,
    required this.price,
    List<Participant>? participants,
  }) : participants = participants ?? [],
       total = price * quantity;

  // Asynchronous factory method to generate ID
  static Future<MenuItem> create({
    required String name,
    required int quantity,
    required double price,
  }) async {
    final id = await IdGeneratorUtil.generateId(IdentifierType.menuItem);
    return MenuItem._(uid: id, name: name, quantity: quantity, price: price);
  }

  MenuItem copyWith({
    String? id,
    String? name,
    int? quantity,
    double? price,
    List<Participant>? participants,
  }) {
    return MenuItem(
      uid: id ?? uid,
      name: name ?? this.name,
      quantity: quantity ?? this.quantity,
      price: price ?? this.price,
      participants:
          participants ??
          List.from(this.participants), // Prevent list mutation issues
    );
  }

  Map<String, dynamic> toMap(String receiptId) {
    return {
      'id': uid,
      'name': name,
      'quantity': quantity,
      'price': price,
      'receipt_id': receiptId,
    };
  }

  factory MenuItem.fromMap(Map<String, dynamic> map, List<Participant> participants) {
    return MenuItem(
      uid: map['id'],
      name: map['name'],
      quantity: map['quantity'],
      price: map['price'],
      participants: participants,
    );
  }
}
