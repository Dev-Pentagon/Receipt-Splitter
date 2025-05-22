import 'package:flutter/services.dart';
import 'package:intl/intl.dart';
import 'package:pdf/pdf.dart';
import 'package:pdf/widgets.dart' as pw;
import 'package:printing/printing.dart';
import 'package:share_plus/share_plus.dart';
import 'package:path_provider/path_provider.dart';
import 'dart:io';

import 'package:receipt_splitter/model/receipt.dart';
import 'package:receipt_splitter/util/format_currency_util.dart';

class ExportUtil {
  static Future<Uint8List> _createPdf({required Receipt receipt}) async {
    final pdf = pw.Document();
    final formatCurrencyUtil = FormatCurrencyUtil();

    final fontData = await rootBundle.load('fonts/NotoSans-Regular.ttf');
    final ttf = pw.Font.ttf(fontData);

    pdf.addPage(
      pw.MultiPage(
        theme: pw.ThemeData.withFont(base: ttf),
        build:
            (context) => [
              pw.Header(
                level: 0,
                child: pw.Row(
                  mainAxisAlignment: pw.MainAxisAlignment.spaceBetween,
                  children: [
                    pw.Text(receipt.name ?? 'Receipt Details', style: pw.TextStyle(fontSize: 24, fontWeight: pw.FontWeight.bold)),
                    pw.Text(DateFormat('dd MMMM yyyy').format(receipt.date ?? DateTime.now()), style: pw.TextStyle(fontSize: 12, color: PdfColors.grey)),
                  ],
                ),
              ),

              pw.SizedBox(height: 10),
              ...receipt.bill.map((bill) {
                return pw.Column(
                  crossAxisAlignment: pw.CrossAxisAlignment.start,
                  children: [
                    pw.Text(bill.participant.name, style: pw.TextStyle(fontSize: 18, fontWeight: pw.FontWeight.bold)),
                    pw.SizedBox(height: 6),
                    ...bill.items.map(
                      (item) => pw.Row(
                        mainAxisAlignment: pw.MainAxisAlignment.spaceBetween,
                        children: [pw.Text(item.name), pw.Text(formatCurrencyUtil.formatAmountWithCode(item.totalPrice))],
                      ),
                    ),
                    pw.Divider(),
                    pw.Row(
                      mainAxisAlignment: pw.MainAxisAlignment.spaceBetween,
                      children: [pw.Text(formatCurrencyUtil.formatTaxTitle(receipt.tax!, receipt.taxType!)), pw.Text(formatCurrencyUtil.formatAmountWithCode(bill.totalTax))],
                    ),
                    pw.Row(
                      mainAxisAlignment: pw.MainAxisAlignment.spaceBetween,
                      children: [
                        pw.Text(formatCurrencyUtil.formatServiceChargeTitle(receipt.serviceCharges!)),
                        pw.Text(formatCurrencyUtil.formatAmountWithCode(bill.serviceCharge)),
                      ],
                    ),
                    pw.SizedBox(height: 4),
                    pw.Row(
                      mainAxisAlignment: pw.MainAxisAlignment.spaceBetween,
                      children: [
                        pw.Text("Total", style: pw.TextStyle(fontWeight: pw.FontWeight.bold)),
                        pw.Text(formatCurrencyUtil.formatAmountWithCode(bill.totalPrice), style: pw.TextStyle(fontWeight: pw.FontWeight.bold)),
                      ],
                    ),
                    pw.Divider(thickness: 2),
                    pw.SizedBox(height: 10),
                  ],
                );
              }),
              pw.SizedBox(height: 20),
              pw.Text("Summary", style: pw.TextStyle(fontSize: 20, fontWeight: pw.FontWeight.bold)),
              pw.SizedBox(height: 8),
              pw.Row(mainAxisAlignment: pw.MainAxisAlignment.spaceBetween, children: [pw.Text("Subtotal"), pw.Text(formatCurrencyUtil.formatAmountWithCode(receipt.subTotal))]),
              pw.Row(
                mainAxisAlignment: pw.MainAxisAlignment.spaceBetween,
                children: [pw.Text(formatCurrencyUtil.formatTaxTitle(receipt.tax!, receipt.taxType!)), pw.Text(formatCurrencyUtil.formatAmountWithCode(receipt.taxAmount))],
              ),
              pw.Row(
                mainAxisAlignment: pw.MainAxisAlignment.spaceBetween,
                children: [
                  pw.Text(formatCurrencyUtil.formatServiceChargeTitle(receipt.serviceCharges!)),
                  pw.Text(formatCurrencyUtil.formatAmountWithCode(receipt.serviceChargesAmount)),
                ],
              ),
              pw.Divider(),
              pw.Row(
                mainAxisAlignment: pw.MainAxisAlignment.spaceBetween,
                children: [
                  pw.Text("Total", style: pw.TextStyle(fontWeight: pw.FontWeight.bold)),
                  pw.Text(formatCurrencyUtil.formatAmountWithCode(receipt.total), style: pw.TextStyle(fontWeight: pw.FontWeight.bold)),
                ],
              ),
            ],
      ),
    );

    return pdf.save();
  }

  static Future<void> exportPdf({required Receipt receipt}) async {
    final pdfBytes = await _createPdf(receipt: receipt);

    final fileName = "${receipt.name ?? 'Receipt'} ${DateFormat('dd MMM yyyy').format(receipt.date ?? DateTime.now())}.pdf";

    await Printing.layoutPdf(name: fileName, onLayout: (PdfPageFormat format) async => pdfBytes);
  }

  static Future<void> sharePdf({required Receipt receipt}) async {
    final pdfBytes = await _createPdf(receipt: receipt);

    final fileName = "${receipt.name ?? 'Receipt'} ${DateFormat('dd MMM yyyy').format(receipt.date ?? DateTime.now())}.pdf";

    final directory = await getTemporaryDirectory();
    final file = File("${directory.path}/$fileName");

    await file.writeAsBytes(pdfBytes);

    await SharePlus.instance.share(
      ShareParams(text: 'Here is your \'${receipt.name}\' PDF for ${DateFormat('dd MM yyyy').format(receipt.date!)}.', files: [XFile(file.path, mimeType: 'application/pdf', name: fileName)]),
    );
  }
}
