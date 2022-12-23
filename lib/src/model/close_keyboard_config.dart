import 'dart:ui';

class CloseKeyboardConfig {
  const CloseKeyboardConfig({
    this.clearFocus = true,
    this.onKeyboardClosed,
  });

  final bool clearFocus;
  final VoidCallback? onKeyboardClosed;
}
