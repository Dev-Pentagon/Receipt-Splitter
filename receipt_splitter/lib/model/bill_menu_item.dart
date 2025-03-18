import 'tax_type.dart';

/// A bill-specific representation of a menu item for a participant.
/// It holds the item's name, the split total price for the participant,
/// how many participants shared the item, the tax amount for the participant,
/// the tax percentage, and the tax type.
class BillMenuItem {
  final String name;
  final double totalPrice;
  final int participantsCount;
  final double taxAmount;
  final double taxPercentage;
  final TaxType taxType;

  BillMenuItem({
    required this.name,
    required this.totalPrice,
    required this.participantsCount,
    required this.taxAmount,
    required this.taxPercentage,
    required this.taxType,
  });
}