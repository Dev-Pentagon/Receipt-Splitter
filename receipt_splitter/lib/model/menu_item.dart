import 'package:receipt_splitter/model/participant.dart';

class MenuItem {
  final int id;
  final String name;
  final int quantity;
  final double price;
  double? total;
  List<Participant> participants;

  MenuItem({
    required this.id,
    required this.name,
    required this.quantity,
    required this.price,
    this.participants = const [],
  }) : total = _calculateTotalAmount(price, quantity);

  static double _calculateTotalAmount(double price, int quantity) => price * quantity;
}