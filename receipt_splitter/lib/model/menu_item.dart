import 'package:receipt_splitter/model/participant.dart';
import 'package:receipt_splitter/module/util/id_generator_util.dart';

import '../config/app_config.dart';

class MenuItem {
  final String id;
  final String name;
  final int quantity;
  final double price;
  final double total;
  final List<Participant> participants;

  // Private constructor for internal use
  MenuItem._({
    required this.id,
    required this.name,
    required this.quantity,
    required this.price,
  }) : total = price * quantity,
       participants = [];

  // Standard constructor (requires id)
  MenuItem({
    required this.id,
    required this.name,
    required this.quantity,
    required this.price,
    List<Participant>? participants,
  })  : participants = participants ?? [],
        total = price * quantity;

  // Asynchronous factory method to generate ID
  static Future<MenuItem> create({
    required String name,
    required int quantity,
    required double price,
  }) async {
    final id = await IdGeneratorUtil.generateId(IdentifierType.menuItem);
    return MenuItem._(
      id: id,
      name: name,
      quantity: quantity,
      price: price,
    );
  }

  MenuItem copyWith({
    String? id,
    String? name,
    int? quantity,
    double? price,
    List<Participant>? participants,
  }) {
    return MenuItem(
      id: id ?? this.id,
      name: name ?? this.name,
      quantity: quantity ?? this.quantity,
      price: price ?? this.price,
      participants: participants ?? List.from(this.participants), // Prevent list mutation issues
    );
  }
}
