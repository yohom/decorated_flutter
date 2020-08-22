import 'package:flutter/material.dart';
import 'package:oktoast/oktoast.dart';

void toast(
  String message, {
  ToastPosition position = ToastPosition.center,
  double radius,
  EdgeInsets padding,
  TextStyle textStyle,
  VoidCallback onDismiss,
  bool dismissOtherToast = true,
  TextAlign textAlign,
  bool error = false,
}) {
  showToast(
    message,
    position: position,
    radius: radius,
    textPadding: padding,
    textStyle: textStyle,
    onDismiss: onDismiss,
    dismissOtherToast: dismissOtherToast,
    textAlign: textAlign,
  );
}
