import 'package:decorated_flutter/decorated_flutter.dart';
import 'package:flutter/material.dart';
import 'package:oktoast/oktoast.dart';

const _duration = 2000;

void toast(
  String message, {
  ToastPosition position = ToastPosition.center,
  double radius = 32,
  EdgeInsets padding = const EdgeInsets.symmetric(
    vertical: kSpaceLittleBig,
    horizontal: kSpaceBig,
  ),
  TextStyle textStyle,
  VoidCallback onDismiss,
  bool dismissOtherToast = true,
  TextAlign textAlign,
  bool error = false,
}) {
  showToast(
    message,
    position: position,
    backgroundColor: error ? Colors.red : Colors.grey,
    radius: radius,
    textPadding: padding,
    textStyle: textStyle,
    onDismiss: onDismiss,
    dismissOtherToast: dismissOtherToast,
    textAlign: textAlign,
  );
}
