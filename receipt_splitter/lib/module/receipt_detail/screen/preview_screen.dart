import 'package:flutter/material.dart';
import 'package:receipt_splitter/model/receipt.dart';

import '../../../constants/strings.dart';

class PreviewScreen extends StatelessWidget {
  static const String preview = '/preview';

  final Receipt receipt;
  const PreviewScreen({super.key, required this.receipt});

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
      body: const Center(child: Text('Preview Screen', style: TextStyle(fontSize: 24))),
      bottomNavigationBar: BottomAppBar(
        height: 215,
        child: Column(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            Column(
              spacing: 12,
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                rowForAmounts(context, title: SUBTOTAL.toUpperCase(), amount: receipt.subTotal),
                rowForAmounts(context, title: TAX, amount: receipt.taxAmount),
                rowForAmounts(context, title: SERVICE_CHARGE, amount: receipt.serviceChargesAmount),
                rowForAmounts(context, title: TOTAL.toUpperCase(), amount: receipt.total, isBold: true),
              ],
            ),
            Divider(height: 1, thickness: 1, color: Theme.of(context).colorScheme.outlineVariant),
            Row(
              spacing: 15,
              mainAxisAlignment: MainAxisAlignment.end,
              children: [
                OutlinedButton.icon(onPressed: () {}, label: Text(EXPORT), icon: const Icon(Icons.file_open_outlined)),
                FilledButton.icon(
                  onPressed: () {},
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

  Widget rowForAmounts(BuildContext context, {required String title, required String amount, bool isBold = false}) {
    TextStyle textStyle = isBold ? Theme.of(context).textTheme.titleLarge! : Theme.of(context).textTheme.bodyMedium!;

    return Row(mainAxisAlignment: MainAxisAlignment.spaceBetween, children: [Text(title, style: textStyle), Text(amount, style: textStyle)]);
  }
}
