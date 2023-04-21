import 'package:decorated_flutter/decorated_flutter.dart';
import 'package:flutter/material.dart';

class AnimatedVisibility extends StatelessWidget {
  const AnimatedVisibility({
    super.key,
    required this.visible,
    required this.duration,
    this.reverseDuration,
    this.margin,
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
  final EdgeInsets? margin;
  final Widget child;

  @override
  Widget build(BuildContext context) {
    Widget result = AnimatedSize(
      duration: duration,
      reverseDuration: reverseDuration,
      alignment: alignment,
      curve: curve,
      clipBehavior: clipBehavior,
      child: visible ? child : NIL,
    );

    if (margin != null) {
      result = Padding(padding: margin!, child: result);
    }

    return result;
  }
}
