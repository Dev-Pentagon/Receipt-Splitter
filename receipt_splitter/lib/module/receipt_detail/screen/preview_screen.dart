import 'package:flutter/material.dart';
import 'package:receipt_splitter/common/layout_builder_widget.dart';
import 'package:receipt_splitter/extension/route_extension.dart';
import 'package:receipt_splitter/model/participant_bill.dart';
import 'package:receipt_splitter/model/receipt.dart';
import 'package:receipt_splitter/module/receipt_detail/common/participant_avatar.dart';

import '../../../constants/strings.dart';
import '../../../util/format_currency_util.dart';
import '../../receipt_list/screen/receipt_list_screen.dart';

class PreviewScreen extends StatelessWidget {
  static const String preview = '/preview';

  final Receipt receipt;
  PreviewScreen({super.key, required this.receipt});

  final FormatCurrencyUtil formatCurrencyUtil = FormatCurrencyUtil();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Preview'),
        centerTitle: true,
        actions: [
          IconButton(
            icon: const Icon(Icons.share),
            onPressed: () {
              // Save action
            },
          ),
        ],
      ),
      body: LayoutBuilderWidget(
        top: 0,
        bottom: 0,
        child: ListView.separated(
          itemCount: receipt.bill.length,
          itemBuilder: (context, index) {
            final ParticipantBill participantBill = receipt.bill[index];
            return ExpansionTile(
              visualDensity: VisualDensity.compact,
              backgroundColor: Theme.of(context).colorScheme.surfaceContainer,
              maintainState: true,
              shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(8), side: BorderSide(color: Theme.of(context).colorScheme.outlineVariant)),
              collapsedShape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(8), side: BorderSide(color: Theme.of(context).colorScheme.outlineVariant)),
              tilePadding: const EdgeInsets.symmetric(horizontal: 8, vertical: 8),
              leading: ParticipantAvatar(participant: participantBill.participant, width: 40, height: 40),
              title: Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Text(participantBill.participant.name, style: Theme.of(context).textTheme.bodyLarge),
                  Text(formatCurrencyUtil.formatAmount(participantBill.totalPrice), style: Theme.of(context).textTheme.labelMedium?.copyWith(color: Theme.of(context).colorScheme.onSurfaceVariant)),
                ],
              ),
              childrenPadding: const EdgeInsets.symmetric(vertical: 3),
              children: [
                ...participantBill.items.map((item) {
                  return rowForAmounts(context, title: item.name, amount: formatCurrencyUtil.formatAmount(item.totalPrice), horizontalPadding: 16, verticalPadding: 4);
                }),
                // tax and service charge
                rowForAmounts(
                  context,
                  title: formatCurrencyUtil.formatTaxTitle(receipt.tax!, receipt.taxType!),
                  amount: formatCurrencyUtil.formatAmount(participantBill.totalTax),
                  horizontalPadding: 16,
                  verticalPadding: 4,
                ),
                rowForAmounts(
                  context,
                  title: formatCurrencyUtil.formatServiceChargeTitle(receipt.serviceCharges!),
                  amount: formatCurrencyUtil.formatAmount(participantBill.serviceCharge),
                  horizontalPadding: 16,
                  verticalPadding: 4,
                ),
              ],
            );
          },
          separatorBuilder: (context, index) => const Divider(height: 10, thickness: 1, color: Colors.transparent),
        ),
      ),
      bottomNavigationBar: BottomAppBar(
        padding: const EdgeInsets.fromLTRB(15, 20, 15, 0),
        height: 215,
        child: Column(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            Column(
              spacing: 12,
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                rowForAmounts(context, title: SUBTOTAL.toUpperCase(), amount: formatCurrencyUtil.formatAmount(receipt.subTotal)),
                rowForAmounts(context, title: formatCurrencyUtil.formatTaxTitle(receipt.tax!, receipt.taxType!), amount: formatCurrencyUtil.formatAmount(receipt.taxAmount)),
                rowForAmounts(context, title: formatCurrencyUtil.formatServiceChargeTitle(receipt.serviceCharges!), amount: formatCurrencyUtil.formatAmount(receipt.serviceChargesAmount)),
                rowForAmounts(context, title: TOTAL.toUpperCase(), amount: formatCurrencyUtil.formatAmount(receipt.total), isBold: true),
              ],
            ),
            Divider(height: 1, thickness: 1, color: Theme.of(context).colorScheme.outlineVariant),
            Row(
              spacing: 15,
              mainAxisAlignment: MainAxisAlignment.end,
              children: [
                OutlinedButton.icon(onPressed: () {}, label: Text(EXPORT), icon: const Icon(Icons.file_open_outlined)),
                FilledButton.icon(
                  onPressed: () {
                    // replace whole navigation stack with list screen
                    context.pushNamedAndRemoveUntil(ReceiptListScreen.receiptSplit);
                  },
                  label: Text(DONE),
                  icon: const Icon(Icons.check),
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }

  Widget rowForAmounts(BuildContext context, {required String title, required String amount, bool isBold = false, double horizontalPadding = 0, double verticalPadding = 0}) {
    TextStyle textStyle = isBold ? Theme.of(context).textTheme.titleLarge! : Theme.of(context).textTheme.bodyMedium!;

    return Padding(
      padding: EdgeInsets.symmetric(horizontal: horizontalPadding, vertical: verticalPadding),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Text(title, style: textStyle.copyWith(fontWeight: isBold ? FontWeight.w600 : FontWeight.w400)),
          Text(amount, style: textStyle.copyWith(color: Theme.of(context).colorScheme.onSurfaceVariant, fontWeight: isBold ? FontWeight.w600 : FontWeight.w400)),
        ],
      ),
    );
  }
}
