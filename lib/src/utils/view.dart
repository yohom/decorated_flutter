import 'package:decorated_flutter/decorated_flutter.dart';
import 'package:flutter/material.dart';

void toast(
  String? message, {
  ToastPosition position = const ToastPosition(
    align: Alignment.topCenter,
    offset: 0,
  ),
  double radius = 32,
  EdgeInsets padding = const EdgeInsets.symmetric(horizontal: 24, vertical: 12),
  TextStyle textStyle = const TextStyle(color: Colors.black),
  VoidCallback? onDismiss,
  bool dismissOtherToast = true,
  TextAlign textAlign = TextAlign.center,
  Duration? duration,
  Color backgroundColor = Colors.white,
  bool error = false,
}) {
  if (isNotEmpty(message)) {
    showToastWidget(
      position: position,
      dismissOtherToast: dismissOtherToast,
      onDismiss: onDismiss,
      duration: duration,
      DecoratedText(
        message,
        safeArea: const SafeAreaConfig(inner: false),
        padding: padding,
        textAlign: textAlign,
        style: textStyle.copyWith(color: error ? Colors.white : null),
        decoration: BoxDecoration(
          color: error ? Colors.red : backgroundColor,
          boxShadow: [
            BoxShadow(
              blurRadius: 4,
              color: Colors.grey.shade100,
              spreadRadius: 8,
            ),
          ],
          borderRadius: BorderRadius.circular(radius),
        ),
      ),
    );
  } else {
    L.w('toast传入null值, 略过');
  }
}
