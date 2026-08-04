import 'package:flutter/material.dart';
import 'package:loader_overlay/loader_overlay.dart';
import 'package:toastification/toastification.dart';

abstract final class AppFeedback {
  static void showLoading(BuildContext context) => context.loaderOverlay.show();
  static void hideLoading(BuildContext context) => context.loaderOverlay.hide();

  static void success(String message) =>
      _show(message, ToastificationType.success);
  static void error(String message) => _show(message, ToastificationType.error);
  static void info(String message) => _show(message, ToastificationType.info);

  static void _show(String message, ToastificationType type) {
    toastification.show(
      type: type,
      title: Text(message),
      autoCloseDuration: const Duration(seconds: 4),
      alignment: Alignment.topCenter,
      showProgressBar: false,
    );
  }
}
