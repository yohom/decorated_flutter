import 'package:decorated_flutter/decorated_flutter.dart';
import 'package:flutter/material.dart';

class AnimatedVisibility extends StatelessWidget {
  const AnimatedVisibility({
    super.key,
    required this.visible,
    this.duration = const Duration(milliseconds: 320),
    this.reverseDuration,
    this.margin,
    this.alignment = Alignment.topCenter,
    this.clipBehavior = Clip.hardEdge,
    this.curve = Curves.ease,
    required this.child,
    this.placeholder = NIL,
  }) : visibleStream = null;

  const AnimatedVisibility.reactive(
    Stream<bool> this.visibleStream, {
    super.key,
    required bool initialData,
    this.duration = const Duration(milliseconds: 320),
    this.reverseDuration,
    this.margin,
    this.alignment = Alignment.topCenter,
    this.clipBehavior = Clip.hardEdge,
    this.curve = Curves.ease,
    required this.child,
    this.placeholder = NIL,
  }) : visible = initialData;

  final bool visible;
  final Stream<bool>? visibleStream;
  final Duration duration;
  final Duration? reverseDuration;
  final Alignment alignment;
  final Clip clipBehavior;
  final Curve curve;
  final EdgeInsets? margin;
  final Widget child;
  final Widget placeholder;

  @override
  Widget build(BuildContext context) {
    Widget result;

    if (visibleStream != null) {
      result = StreamBuilder<bool>(
        initialData: visible,
        stream: visibleStream,
        builder: (context, snapshot) {
          return AnimatedSize(
            duration: duration,
            reverseDuration: reverseDuration,
            alignment: alignment,
            curve: curve,
            clipBehavior: clipBehavior,
            child: snapshot.data == true ? child : placeholder,
          );
        },
      );
    } else {
      result = AnimatedSize(
        duration: duration,
        reverseDuration: reverseDuration,
        alignment: alignment,
        curve: curve,
        clipBehavior: clipBehavior,
        child: visible ? child : placeholder,
      );
    }

    if (margin != null) {
      result = Padding(padding: margin!, child: result);
    }

    return result;
  }
}
