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
            // 参考 https://github.com/flutter/flutter/issues/54277#issuecomment-867119458
            final FocusScopeNode currentScope = FocusScope.of(context);
            if (!currentScope.hasPrimaryFocus && currentScope.hasFocus) {
              FocusManager.instance.primaryFocus?.unfocus();
            }
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
