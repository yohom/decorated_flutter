import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';

class ValueListenableSwitcher<T> extends StatelessWidget {
  const ValueListenableSwitcher({
    Key? key,
    required this.valueListenable,
    required this.duration,
    required this.builder,
    this.switchInCurve = Curves.decelerate,
    this.switchOutCurve = Curves.decelerate,
    this.width,
    this.height,
    this.margin,
    this.child,
  }) : super(key: key);

  final ValueListenable<T> valueListenable;
  final Duration duration;
  final ValueWidgetBuilder<T> builder;
  final Curve switchInCurve;
  final Curve switchOutCurve;
  final double? width, height;
  final EdgeInsets? margin;
  final Widget? child;

  @override
  Widget build(BuildContext context) {
    Widget result = ValueListenableBuilder<T>(
      valueListenable: valueListenable,
      child: child,
      builder: (context, value, child) {
        return AnimatedSwitcher(
          duration: duration,
          switchInCurve: switchInCurve,
          switchOutCurve: switchOutCurve,
          child: builder(context, value, child),
        );
      },
    );

    if (width != null || height != null || margin != null) {
      return Container(
        margin: margin,
        width: width,
        height: height,
        child: result,
      );
    }

    return result;
  }
}
