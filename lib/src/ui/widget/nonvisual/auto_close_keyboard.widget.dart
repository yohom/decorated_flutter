import 'package:decorated_flutter/decorated_flutter.dart';
import 'package:flutter/material.dart';

class AutoCloseKeyboard extends StatelessWidget {
  final Widget? child;

  const AutoCloseKeyboard({
    Key? key,
    this.config = const CloseKeyboardConfig(),
    this.child,
  }) : super(key: key);

  final CloseKeyboardConfig config;

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: () {
        if (config.clearFocus) {
          FocusScope.of(context).unfocus();
        } else {
          hideKeyboard();
        }
      },
      child: child,
    );
  }
}
