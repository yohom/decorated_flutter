import 'dart:ui';

class CloseKeyboardConfig {
  const CloseKeyboardConfig({
    this.enabled = true,
    this.clearFocus = true,
    this.onKeyboardClosed,
  });

  final bool enabled, clearFocus;
  final VoidCallback? onKeyboardClosed;
}
