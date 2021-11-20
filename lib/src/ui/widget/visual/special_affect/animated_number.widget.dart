import 'package:flutter/material.dart';

class AnimatedInt extends ImplicitlyAnimatedWidget {
  const AnimatedInt(
    this.number, {
    Key? key,
    required this.builder,
    Duration duration = const Duration(milliseconds: 2000),
    Curve curve = Curves.decelerate,
  }) : super(duration: duration, curve: curve, key: key);

  final int number;
  final Widget Function(int) builder;

  @override
  ImplicitlyAnimatedWidgetState<ImplicitlyAnimatedWidget> createState() =>
      _AnimatedCountState();
}

class _AnimatedCountState extends AnimatedWidgetBaseState<AnimatedInt> {
  Tween<int>? _number;

  @override
  Widget build(BuildContext context) {
    return widget.builder(_number?.evaluate(animation) ?? 0);
  }

  @override
  void forEachTween(TweenVisitor<dynamic> visitor) {
    _number = visitor(
      _number,
      widget.number,
      (value) => IntTween(begin: value),
    ) as Tween<int>?;
  }
}

class AnimatedDouble extends ImplicitlyAnimatedWidget {
  const AnimatedDouble(
    this.number, {
    Key? key,
    required this.builder,
    Duration duration = const Duration(milliseconds: 2000),
    Curve curve = Curves.decelerate,
  }) : super(duration: duration, curve: curve, key: key);

  final double number;
  final Widget Function(double) builder;

  @override
  ImplicitlyAnimatedWidgetState<ImplicitlyAnimatedWidget> createState() =>
      _AnimatedDoubleState();
}

class _AnimatedDoubleState extends AnimatedWidgetBaseState<AnimatedDouble> {
  Tween<double>? _number;

  @override
  Widget build(BuildContext context) {
    return widget.builder(_number?.evaluate(animation) ?? 0);
  }

  @override
  void forEachTween(TweenVisitor<dynamic> visitor) {
    _number = visitor(
      _number,
      widget.number,
      (value) => Tween<double>(begin: value),
    ) as Tween<double>?;
  }
}
