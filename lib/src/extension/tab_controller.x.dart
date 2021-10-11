import 'dart:math';

import 'package:flutter/material.dart';

extension TabControllerX on TabController {
  /// 滚动到下一个tab
  void animateToNext({
    Duration duration = kTabScrollDuration,
    Curve curve = Curves.ease,
  }) {
    animateTo(min(index + 1, length - 1), duration: duration, curve: curve);
  }

  /// 滚动到上一个tab
  void animateToPrev({
    Duration duration = kTabScrollDuration,
    Curve curve = Curves.ease,
  }) {
    animateTo(max(index - 1, 0), duration: duration, curve: curve);
  }
}
