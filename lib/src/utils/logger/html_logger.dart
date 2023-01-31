import 'package:flutter/foundation.dart';

class Logger {
  /// 初始化日志
  Future<void> init() async {
    // do thing
  }

  /// 日志所在路径
  dynamic get logDir => 'invalid';

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

  void v(Object content) {
    if (!kReleaseMode) {
      debugPrint(content.toString());
    }
  }

  void dispose() {}
}
