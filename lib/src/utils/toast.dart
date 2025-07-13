import 'package:decorated_flutter/src/utils/utils.export.dart';
import 'package:flutter/material.dart';
import 'package:toastification/toastification.dart';

void toast(
  String? message, {
  double radius = 16,
  @Deprecated('已无作用') EdgeInsets? padding,
  TextStyle textStyle = const TextStyle(color: Colors.black),
  VoidCallback? onDismiss,
  @Deprecated('已无作用') bool dismissOtherToast = true,
  @Deprecated('已无作用') TextAlign textAlign = TextAlign.center,
  Duration duration = const Duration(seconds: 3),
  Color backgroundColor = Colors.white,
  bool error = false,
  Alignment alignment = Alignment.center,
}) {
  if (isNotEmpty(message)) {
    toastification.show(
      overlayState: gNavigator.overlay,
      title: Text(message!, style: textStyle),
      autoCloseDuration: duration,
      alignment: alignment,
      callbacks: ToastificationCallbacks(
        onDismissed: (_) => onDismiss?.call(),
      ),
      type: error ? ToastificationType.error : ToastificationType.info,
      padding: EdgeInsets.symmetric(horizontal: 16, vertical: 12),
      style: error ? ToastificationStyle.flat : ToastificationStyle.simple,
      animationBuilder: (_, animation, alignment, child) {
        return FadeTransition(opacity: animation, child: child);
      },
      closeButtonShowType: CloseButtonShowType.none,
      backgroundColor: backgroundColor,
      borderRadius: BorderRadius.circular(radius),
    );
  } else {
    L.w('[DECORATED_FLUTTER] toast传入null值, 略过');
  }
}
