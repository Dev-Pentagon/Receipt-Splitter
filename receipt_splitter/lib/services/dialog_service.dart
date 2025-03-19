import 'package:flutter/material.dart';

class DialogService {
  static Future<void> showSuccessDialog({
    required BuildContext context,
    required String title,
    required String message,
    VoidCallback? onConfirm,
  }) {
    return _showDialog(
      context: context,
      title: title,
      message: message,
      confirmText: "OK",
      onConfirm: onConfirm ?? () => Navigator.pop(context),
    );
  }

  static Future<void> showWarningDialog({
    required BuildContext context,
    required String title,
    required String message,
    VoidCallback? onConfirm,
  }) {
    return _showDialog(
      context: context,
      title: title,
      message: message,
      confirmText: "Understood",
      onConfirm: onConfirm ?? () => Navigator.pop(context),
    );
  }

  static Future<void> showErrorDialog({
    required BuildContext context,
    required String title,
    required String message,
    VoidCallback? onConfirm,
  }) {
    return _showDialog(
      context: context,
      title: title,
      message: message,
      confirmText: "Retry",
      onConfirm: onConfirm ?? () => Navigator.pop(context),
    );
  }

  static Future<void> showConfirmationDialog({
    required BuildContext context,
    required String title,
    required String message,
    required VoidCallback onConfirm,
    VoidCallback? onCancel,
    String confirmText = "Yes",
    String cancelText = "No",
  }) {
    return _showDialog(
      context: context,
      title: title,
      message: message,
      confirmText: confirmText,
      cancelText: cancelText,
      onConfirm: onConfirm,
      onCancel: onCancel ?? () => Navigator.pop(context),
    );
  }

  static Future<void> showLoadingDialog({required BuildContext context}) async {
    showDialog(
      context: context,
      barrierDismissible: false, // Prevents dismissing
      builder:
          (context) => Dialog(
            shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(16),
            ),
            child: Padding(
              padding: const EdgeInsets.all(20.0),
              child: Column(
                mainAxisSize: MainAxisSize.min,
                children: [
                  CircularProgressIndicator(),
                  const SizedBox(height: 16),
                  Text("Loading...", style: TextStyle(fontSize: 16)),
                ],
              ),
            ),
          ),
    );
  }

  /// Generic Dialog Builder
  static Future<void> _showDialog({
    required BuildContext context,
    required String title,
    required String message,
    required String confirmText,
    VoidCallback? onConfirm,
    String? cancelText,
    VoidCallback? onCancel,
  }) {
    return showDialog(
      context: context,
      barrierDismissible: false,
      builder:
          (context) => AlertDialog(
            shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(16),
            ),
            title: Text(title, style: TextStyle(fontWeight: FontWeight.bold)),
            content: Text(message),
            actions: [
              if (cancelText != null)
                TextButton(onPressed: onCancel, child: Text(cancelText)),
              TextButton(onPressed: onConfirm, child: Text(confirmText)),
            ],
          ),
    );
  }

  static Future<void> customDialog(BuildContext context, Widget widget) {
    return showDialog(context: context, builder: (context) => widget);
  }
}
