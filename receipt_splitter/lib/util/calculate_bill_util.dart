import '../model/bill_menu_item.dart';
import '../model/participant_bill.dart';
import '../model/receipt.dart';
import '../model/tax_type.dart';

/// Utility service that calculates each participant's bill breakdown.
class CalculateBillUtil {
  /// Splits the [receipt] among its participants.
  ///
  /// For each [MenuItem] in the receipt:
  /// - The item's total price and tax (using receipt.tax percentage) are divided among
  ///   the participants who shared that item.
  ///
  /// Then, the service charge is computed from the overall receipt subtotal (using
  /// receipt.serviceCharges percentage) and divided equally among all participants.
  static List<ParticipantBill> splitReceipt(Receipt receipt) {
    // Map to collect bill items for each participant.
    final Map<String, List<BillMenuItem>> participantItems = {};
    for (final participant in receipt.participants) {
      participantItems[participant.uid] = [];
    }

    // Process each MenuItem in the receipt.
    for (final item in receipt.items) {
      final int numItemParticipants = item.participants.length;
      if (numItemParticipants == 0) {
        continue; // Skip items with no assigned participants.
      }

      // Calculate the item's total price (price * quantity).
      final double itemTotal = item.total;

      // Calculate the tax for the entire item.
      final double itemTaxTotal = itemTotal * ((receipt.tax ?? 0) / 100);

      // The share for each participant.
      final double sharePrice = itemTotal / numItemParticipants;
      final double shareTax = itemTaxTotal / numItemParticipants;

      // For each participant assigned to this item, create a BillMenuItem.
      for (final participant in item.participants) {
        final billItem = BillMenuItem(
          name: item.name,
          totalPrice: sharePrice,
          participantsCount: numItemParticipants,
          taxAmount: shareTax,
          taxPercentage: receipt.tax ?? 0,
          taxType:
              receipt.taxType ??
              TaxType.exclusive, // Provide a default if null.
        );
        participantItems[participant.uid]!.add(billItem);
      }
    }

    // Compute the global service charge.
    // Calculate the subtotal for the entire receipt.
    final double subtotal = receipt.items.fold(
      0.0,
      (sum, item) => sum + item.total,
    );
    // Total service charge from the receipt.
    final double totalServiceCharge =
        subtotal * ((receipt.serviceCharges ?? 0) / 100);
    // Divide service charge equally among all participants.
    final double serviceChargePerParticipant =
        receipt.participants.isNotEmpty
            ? totalServiceCharge / receipt.participants.length
            : 0.0;

    // Build ParticipantBill for each participant.
    final List<ParticipantBill> bills = [];
    for (final participant in receipt.participants) {
      final items = participantItems[participant.uid]!;
      final totalTax = items.fold(0.0, (sum, item) => sum + item.taxAmount);
      final totalPrice =
          items.fold(0.0, (sum, item) => sum + item.totalPrice) +
          serviceChargePerParticipant +
          (receipt.taxType == TaxType.inclusive ? 0.0 : totalTax);
      bills.add(
        ParticipantBill(
          participant: participant,
          items: items,
          totalTax: totalTax,
          serviceCharge: serviceChargePerParticipant,
          totalPrice: totalPrice,
        ),
      );
    }
    return bills;
  }
}
