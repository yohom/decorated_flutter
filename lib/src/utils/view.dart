import 'package:decorated_flutter/src/utils/utils.export.dart';
import 'package:flutter/material.dart';
import 'package:oktoast/oktoast.dart';

void toast(
  String? message, {
  ToastPosition position = ToastPosition.center,
  double? radius,
  EdgeInsets? padding,
  TextStyle? textStyle,
  VoidCallback? onDismiss,
  bool dismissOtherToast = true,
  TextAlign textAlign = TextAlign.center,
  Duration? duration,
  Color? backgroundColor,
  bool error = false,
}) {
  if (isNotEmpty(message)) {
    showToast(
      message!,
      position: position,
      radius: radius,
      backgroundColor: backgroundColor,
      duration: duration,
      textPadding: padding,
      textStyle: textStyle,
      onDismiss: onDismiss,
      dismissOtherToast: dismissOtherToast,
      textAlign: textAlign,
    );
  } else {
    L.w('toast传入null值, 略过');
  }
}
