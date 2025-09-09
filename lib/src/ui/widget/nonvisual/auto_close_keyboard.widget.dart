import 'package:decorated_flutter/decorated_flutter.dart' hide Actions;
import 'package:flutter/gestures.dart';
import 'package:flutter/material.dart';

/// 参考实现 https://api.flutter.dev/flutter/widgets/EditableTextTapUpOutsideIntent-class.html
class AutoCloseKeyboard extends StatefulWidget {
  const AutoCloseKeyboard({
    super.key,
    this.config = const CloseKeyboardConfig(),
    required this.child,
  });

  final CloseKeyboardConfig config;
  final Widget child;

  @override
  State<AutoCloseKeyboard> createState() => _AutoCloseKeyboardState();
}

class _AutoCloseKeyboardState extends State<AutoCloseKeyboard> {
  PointerDownEvent? _latestPointerDownEvent;

  @override
  Widget build(BuildContext context) {
    if (widget.config.enabled) {
      return Actions(
        actions: <Type, Action<Intent>>{
          EditableTextTapOutsideIntent:
              CallbackAction<EditableTextTapOutsideIntent>(
            onInvoke: _handlePointerDown,
          ),
          EditableTextTapUpOutsideIntent:
              CallbackAction<EditableTextTapUpOutsideIntent>(
            onInvoke: _handlePointerUp,
          ),
        },
        child: widget.child,
      );
    } else {
      return widget.child;
    }
  }

  void _handlePointerUp(EditableTextTapUpOutsideIntent intent) {
    if (_latestPointerDownEvent == null) {
      return;
    }

    final double distance =
        (_latestPointerDownEvent!.position - intent.pointerUpEvent.position)
            .distance;

    // Unfocus on taps but not scrolls.
    // kTouchSlop is a framework constant that is used to determine if a
    // pointer event is a tap or a scroll.
    if (distance < kTouchSlop) {
      intent.focusNode.unfocus();
    }
  }

  void _handlePointerDown(EditableTextTapOutsideIntent intent) {
    // Store the latest pointer down event to calculate the distance between
    // the pointer down and pointer up events later.
    _latestPointerDownEvent = intent.pointerDownEvent;

    if (widget.config.clearFocus) {
      intent.focusNode.unfocus();
    } else {
      hideKeyboard();
    }

    widget.config.onKeyboardClosed?.call();
  }
}
