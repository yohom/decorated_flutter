import 'package:flutter/material.dart';

class AutoScrollBottomSheet extends StatelessWidget {
  const AutoScrollBottomSheet({
    Key key,
    this.duration = const Duration(milliseconds: 100),
    this.curve = Curves.decelerate,
    @required this.child,
  }) : super(key: key);

  final Widget child;
  final Duration duration;
  final Curve curve;

  @override
  Widget build(BuildContext context) {
    return AnimatedPadding(
      padding: MediaQuery.of(context).viewInsets,
      duration: duration,
      curve: curve,
      child: child,
    );
  }
}
