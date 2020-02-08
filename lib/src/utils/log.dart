import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';

class L {
  /// debug模式打印
  static void d(Object content) async {
    if (!kReleaseMode && !kProfileMode) {
      debugPrint(content.toString());
    }
  }

  /// profile模式打印
  static void p(Object content) async {
    if (!kReleaseMode) {
      debugPrint(content.toString());
    }
  }

  /// release模式打印
  static void r(Object content) async {
    debugPrint(content.toString());
  }
}
