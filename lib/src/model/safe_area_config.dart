import 'package:flutter/material.dart';

class SafeAreaConfig {
  final bool top;
  final bool bottom;
  final bool left;
  final bool right;

  /// 作用于内部
  final bool inner;
  final EdgeInsets minimum;

  const SafeAreaConfig({
    this.top = true,
    this.bottom = true,
    this.left = true,
    this.right = true,
    this.inner = true,
    this.minimum = EdgeInsets.zero,
  });

  SafeAreaConfig.top({this.inner = true, double minTop = 0})
      : top = true,
        bottom = false,
        left = false,
        right = false,
        minimum = EdgeInsets.only(top: minTop);

  SafeAreaConfig.bottom({this.inner = true, double minBottom = 0})
      : top = false,
        bottom = true,
        left = false,
        right = false,
        minimum = EdgeInsets.only(bottom: minBottom);

  SafeAreaConfig.left({this.inner = true, double minLeft = 0})
      : top = false,
        bottom = false,
        left = true,
        right = false,
        minimum = EdgeInsets.only(left: minLeft);

  SafeAreaConfig.right({this.inner = true, double minRight = 0})
      : top = false,
        bottom = false,
        left = false,
        right = true,
        minimum = EdgeInsets.only(right: minRight);

  @override
  String toString() {
    return 'SafeAreaConfig{top: $top, bottom: $bottom, left: $left, right: $right, inner: $inner, minimum: $minimum}';
  }
}
