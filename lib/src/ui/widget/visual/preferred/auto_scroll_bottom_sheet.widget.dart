import 'package:decorated_flutter/decorated_flutter.dart';
import 'package:flutter/material.dart';

class AutoScrollBottomSheet extends StatefulWidget {
  const AutoScrollBottomSheet({
    Key? key,
    this.duration = const Duration(milliseconds: 100),
    this.curve = Curves.decelerate,
    required this.child,
  }) : super(key: key);

  final Widget child;
  final Duration duration;
  final Curve curve;

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
      child: AnimatedPadding(
        padding: _padding,
        duration: widget.duration,
        curve: widget.curve,
        child: widget.child,
      ),
    );
  }
}
