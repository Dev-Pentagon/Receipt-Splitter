import 'dart:typed_data';

import 'package:flutter_image_gallery_saver/flutter_image_gallery_saver.dart';

class ExportUtil {
  static Future<void> exportImage({required String fileName, required Uint8List data}) async {
    await FlutterImageGallerySaver.saveImage(data);
  }

  static exportPdf({required String fileName}) {
    return 'Exported';
  }

  static saveFileInStorage({bool inGallery = false}) {}
}
