import 'package:flutter/material.dart';

class SnackbarUtils {
  /// Shows a snackbar at the top of the screen
  static void showTopSnackbar(
    BuildContext context, {
    required String message,
    Color? backgroundColor,
    Duration duration = const Duration(seconds: 3),
    String? actionLabel,
    VoidCallback? onActionPressed,
  }) {
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        content: Text(message),
        backgroundColor: backgroundColor,
        duration: duration,
        behavior: SnackBarBehavior.floating,
        margin: EdgeInsets.only(
          bottom: MediaQuery.of(context).size.height - 120,
          left: 16,
          right: 16,
        ),
        action: actionLabel != null && onActionPressed != null
            ? SnackBarAction(
                label: actionLabel,
                onPressed: onActionPressed,
                textColor: Colors.white,
              )
            : null,
      ),
    );
  }

  /// Shows a success snackbar at the top
  static void showSuccess(
    BuildContext context,
    String message, {
    Duration duration = const Duration(seconds: 3),
    Color? backgroundColor,
  }) {
    showTopSnackbar(
      context,
      message: message,
      backgroundColor: backgroundColor ?? Colors.green,
      duration: duration,
    );
  }

  /// Shows an error snackbar at the top
  static void showError(
    BuildContext context,
    String message, {
    Duration duration = const Duration(seconds: 4),
    Color? backgroundColor,
  }) {
    showTopSnackbar(
      context,
      message: message,
      backgroundColor: backgroundColor ?? Colors.red,
      duration: duration,
    );
  }

  /// Shows an info snackbar at the top
  static void showInfo(
    BuildContext context,
    String message, {
    Duration duration = const Duration(seconds: 3),
    Color? backgroundColor,
  }) {
    showTopSnackbar(
      context,
      message: message,
      backgroundColor: backgroundColor ?? Colors.blue,
      duration: duration,
    );
  }

  /// Shows a warning snackbar at the top
  static void showWarning(
    BuildContext context,
    String message, {
    Duration duration = const Duration(seconds: 4),
    Color? backgroundColor,
  }) {
    showTopSnackbar(
      context,
      message: message,
      backgroundColor: backgroundColor ?? Colors.orange,
      duration: duration,
    );
  }
}
