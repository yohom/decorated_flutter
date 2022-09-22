import 'package:decorated_flutter/decorated_flutter.dart';
import 'package:flutter/material.dart';

class AnimatedVisibility extends StatelessWidget {
  const AnimatedVisibility({
    super.key,
    required this.visible,
    required this.duration,
    this.reverseDuration,
    this.alignment = Alignment.topCenter,
    this.clipBehavior = Clip.hardEdge,
    this.curve = Curves.ease,
    required this.child,
  });

  final bool visible;
  final Duration duration;
  final Duration? reverseDuration;
  final Alignment alignment;
  final Clip clipBehavior;
  final Curve curve;
  final Widget child;

  @override
  Widget build(BuildContext context) {
    return AnimatedSize(
      duration: duration,
      reverseDuration: reverseDuration,
      alignment: alignment,
      curve: curve,
      clipBehavior: clipBehavior,
      child: visible ? child : NIL,
    );
  }
}
