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

  /// 滚动百分比
  double get scrollPercent {
    if (!hasClients) return 0;

    final max = positions.first.maxScrollExtent;
    if (max == 0) return 0;

    final current = positions.first.pixels;
    return current / max;
  }

  /// 距离最大值的偏移量
  double get offsetToMax {
    if (!hasClients) return 0;

    final max = positions.first.maxScrollExtent;
    if (max == 0) return 0;

    final current = positions.first.pixels;
    return max - current;
  }

  void jumpToMin() {
    return jumpTo(0);
  }

  void jumpToMax() {
    return jumpTo(position.maxScrollExtent);
  }
}
