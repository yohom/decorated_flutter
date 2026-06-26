import 'package:decorated_flutter/decorated_flutter.dart';
import 'package:flutter/material.dart';

class AutoScrollBottomSheet extends StatefulWidget {
  const AutoScrollBottomSheet({
    super.key,
    this.duration = Duration.zero,
    this.curve = Curves.decelerate,
    this.backgroundColor,
    this.autoCloseKeyboard = const CloseKeyboardConfig(),
    required this.child,
  });

  final Widget child;
  final Duration duration;
  final Curve curve;
  final Color? backgroundColor;
  final CloseKeyboardConfig autoCloseKeyboard;

  @override
  State<AutoScrollBottomSheet> createState() => _AutoScrollBottomSheetState();
}

class _AutoScrollBottomSheetState extends State<AutoScrollBottomSheet> {
  late EdgeInsets _padding;

  @override
  void initState() {
    super.initState();
    _padding = EdgeInsets.zero;
  }

  @override
  void didChangeDependencies() {
    super.didChangeDependencies();
    _padding = MediaQuery.of(context).viewInsets;
  }

  @override
  Widget build(BuildContext context) {
    return AutoCloseKeyboard(
      config: widget.autoCloseKeyboard,
      child: AnimatedContainer(
        padding: _padding,
        color: widget.backgroundColor,
        duration: widget.duration,
        curve: widget.curve,
        child: widget.child,
      ),
    );
  }
}
