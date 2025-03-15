class MenuItem {
  final int id;
  final String name;
  final int quantity;
  final double price;
  double? total;

  MenuItem({
    required this.id,
    required this.name,
    required this.quantity,
    required this.price,
  }) : total = _calculateTotalAmount(price, quantity);

  static double _calculateTotalAmount(double price, int quantity) => price * quantity;
}