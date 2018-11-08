import 'package:flutter/material.dart';

/// If you're in release mode, const bool.fromEnvironment("dart.vm.product") will be true.
/// If you're in debug mode, assert(() { ...; return true; }); will execute ....
/// If you're in profile mode, neither of the above will happen.
class L {
  static const String tag = 'flutter_framework';

  /// debug模式打印
  static void d(String content) {
    assert(() {
      debugPrint('$tag: $content');
      return true;
    }());
  }

  /// profile模式打印
  static void p(String content) {
    if (!bool.fromEnvironment('dart.vm.product')) {
      debugPrint('$tag: $content');
    }
  }

  /// release模式打印
  static void r(String content) {
    debugPrint('$tag: $content');
  }
}
