import 'package:flutter/cupertino.dart';

extension ScrollControllerX on ScrollController {
  Future<void> animateToMax({
    Duration duration = const Duration(milliseconds: 100),
    Curve curve = Curves.decelerate,
  }) {
    return animateTo(
      position.maxScrollExtent,
      duration: duration,
      curve: curve,
    );
  }

  Future<void> animateToMin({
    Duration duration = const Duration(milliseconds: 100),
    Curve curve = Curves.decelerate,
  }) {
    return animateTo(
      position.minScrollExtent,
      duration: duration,
      curve: curve,
    );
  }

  Future<void> animateBy(
    double offset, {
    Duration duration = const Duration(milliseconds: 100),
    Curve curve = Curves.decelerate,
  }) {
    final target = position.pixels + offset;
    return animateTo(
      target,
      duration: duration,
      curve: curve,
    );
  }

  void jumpToMin() {
    return jumpTo(0);
  }

  void jumpToMax() {
    return jumpTo(position.maxScrollExtent);
  }
}
