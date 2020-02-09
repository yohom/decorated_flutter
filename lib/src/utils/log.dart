import 'package:flutter/foundation.dart';

final _Logger L = _Logger();

class _Logger {
  void d(Object content) {
    if (!kReleaseMode) {
      debugPrint(content.toString());
    }
  }

  void w(Object content) {
    if (!kReleaseMode) {
      debugPrint(content.toString());
    }
  }

  void i(Object content) {
    if (!kReleaseMode) {
      debugPrint(content.toString());
    }
  }

  void e(Object content) {
    if (!kReleaseMode) {
      debugPrint(content.toString());
    }
  }

  /// profile模式打印
  @Deprecated('使用L.d代替')
  void p(Object content) {
    if (!kReleaseMode) {
      debugPrint(content.toString());
    }
  }

  /// release模式打印
  @Deprecated('使用L.d代替')
  void r(Object content) {
    debugPrint(content.toString());
  }
}
