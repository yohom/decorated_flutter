import 'package:flutter/material.dart';

/// If you're in release mode, const bool.fromEnvironment("dart.vm.product") will be true.
/// If you're in debug mode, assert(() { ...; return true; }); will execute ....
/// If you're in profile mode, neither of the above will happen.
class L {
  /// debug模式打印
  static void d(Object content) async {
    assert(() {
      debugPrint(content.toString());
      return true;
    }());
  }

  /// profile模式打印
  static void p(Object content) async {
    if (!bool.fromEnvironment('dart.vm.product')) {
      debugPrint(content.toString());
    }
  }

  /// release模式打印
  static void r(Object content) async {
    debugPrint(content.toString());
  }
}
