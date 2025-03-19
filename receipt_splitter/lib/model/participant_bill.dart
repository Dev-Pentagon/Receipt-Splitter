import 'bill_menu_item.dart';
import 'participant.dart';

/// Contains the bill details for a single participant:
/// - participant: The participant themselves.
/// - items: The list of BillMenuItem representing each item they shared.
/// - totalTax: The sum of tax amounts for all items the participant purchased.
/// - serviceCharge: The service charge for the participant (Receipt service charge divided equally).
class ParticipantBill {
  final Participant participant;
  final List<BillMenuItem> items;
  final double totalTax;
  final double serviceCharge;
  final double totalPrice;

  ParticipantBill({
    required this.participant,
    required this.items,
    required this.totalTax,
    required this.serviceCharge,
    required this.totalPrice,
  });
}
