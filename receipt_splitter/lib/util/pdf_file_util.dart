import 'dart:io';

import 'package:flutter_to_pdf/flutter_to_pdf.dart';
import 'package:path_provider/path_provider.dart';
import 'package:pdf/widgets.dart';

class PdfFileUtil {
  static final ExportDelegate _exportDelegate = ExportDelegate(
    ttfFonts: {
      'Roboto': 'fonts/Roboto-Regular.ttf',
      'Roboto-Medium': 'fonts/Roboto-Medium.ttf',
      'Roboto-Italic': 'fonts/Roboto-Italic.ttf',
      'Roboto-Bold': 'fonts/Roboto-Bold.ttf',
      'Roboto-SemiBold': 'fonts/Roboto-SemiBold.ttf',
      'CupertinoSystemDisplay': 'fonts/Roboto-Regular.ttf',
    },
    options: _exportOptions,
  );

  static final ExportOptions _exportOptions = ExportOptions(
    pageFormatOptions: PageFormatOptions.roll80(),
  );

  static ExportDelegate get exportDelegate => _exportDelegate;

  PdfFileUtil._private();

  static final PdfFileUtil _instance = PdfFileUtil._private();

  factory PdfFileUtil() {
    return _instance;
  }

  static Future<String> exportPdf({
    required String fileName,
    required String frameId,
  }) async {
    final Document pdf = await _exportDelegate.exportToPdfDocument(frameId);

    return _saveFile(pdf, fileName);
  }

  static Future<String> _saveFile(Document document, String name) async {
    final Directory? dir =
        await (Platform.isAndroid
            ? getExternalStorageDirectory()
            : getApplicationDocumentsDirectory());
    if (dir != null) {
      final File file = File('${dir.path}/$name.pdf');

      await file.writeAsBytes(await document.save());
      return file.path;
    } else {
      return '';
    }
  }
}
