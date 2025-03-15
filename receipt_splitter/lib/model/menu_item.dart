import 'package:receipt_splitter/model/participant.dart';

class MenuItem {
  final int id;
  final String name;
  final int quantity;
  final double price;
  final double total;
  final List<Participant> participants;

  MenuItem({
    required this.id,
    required this.name,
    required this.quantity,
    required this.price,
    List<Participant>? participants,
  })  : participants = participants ?? [],
        total = price * quantity; // Calculate total correctly

  MenuItem copyWith({
    int? id,
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