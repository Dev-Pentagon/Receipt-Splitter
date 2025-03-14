class MenuItem {
  final int id;
  final String name;
  final int quantity;
  final double price;
  final double? total;

  MenuItem({
    required this.id,
    required this.name,
    required this.quantity,
    required this.price,
    this.total,
  });
}