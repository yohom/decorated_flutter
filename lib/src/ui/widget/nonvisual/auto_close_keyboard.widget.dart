import 'package:decorated_flutter/decorated_flutter.dart';
import 'package:flutter/material.dart';

class AutoCloseKeyboard extends StatelessWidget {
  const AutoCloseKeyboard({
    super.key,
    this.config = const CloseKeyboardConfig(),
    required this.child,
  });

  final CloseKeyboardConfig config;
  final Widget child;

  @override
  Widget build(BuildContext context) {
    if (config.enabled) {
      return GestureDetector(
        onTap: () {
          if (config.clearFocus) {
            context.clearFocus();
          } else {
            hideKeyboard();
          }
          config.onKeyboardClosed?.call();
        },
        child: child,
      );
    } else {
      return child;
    }
  }
}
