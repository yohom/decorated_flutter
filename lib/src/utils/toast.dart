import 'package:cherry_toast/cherry_toast.dart';
import 'package:cherry_toast/resources/arrays.dart';
import 'package:decorated_flutter/src/utils/utils.export.dart';
import 'package:flutter/material.dart';

void toast(
  String? message, {
  double radius = 16,
  @Deprecated('已无作用') EdgeInsets? padding,
  TextStyle textStyle = const TextStyle(color: Colors.black),
  VoidCallback? onDismiss,
  @Deprecated('已无作用') bool dismissOtherToast = true,
  @Deprecated('已无作用') TextAlign textAlign = TextAlign.center,
  Duration duration = const Duration(seconds: 2),
  Color backgroundColor = Colors.white,
  bool error = false,
}) {
  if (isNotEmpty(message)) {
    const type = AnimationType.fromTop;
    const animationDuration = Duration(milliseconds: 512);
    if (error) {
      CherryToast.error(
        title: Text(message!, style: textStyle),
        animationType: type,
        toastDuration: duration,
        animationDuration: animationDuration,
        onToastClosed: onDismiss,
        backgroundColor: backgroundColor,
        borderRadius: radius,
        enableIconAnimation: false,
        displayCloseButton: true,
      ).show(gNavigatorKey.currentContext!);
    } else {
      CherryToast.info(
        title: Text(message!, style: textStyle),
        animationType: type,
        toastDuration: duration,
        animationDuration: animationDuration,
        onToastClosed: onDismiss,
        backgroundColor: backgroundColor,
        borderRadius: radius,
        enableIconAnimation: false,
        displayCloseButton: true,
      ).show(gNavigatorKey.currentContext!);
    }
  } else {
    L.w('toast传入null值, 略过');
  }
}
