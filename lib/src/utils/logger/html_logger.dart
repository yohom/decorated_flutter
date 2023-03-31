import 'package:flutter/foundation.dart';
import 'package:talker/talker.dart';

class Logger {
  final _talker = Talker();

  /// 初始化日志
  Future<void> init() async {
    // do thing
  }

  /// 日志所在路径
  dynamic get logDir => 'invalid';

  void d(Object content) {
    if (!kReleaseMode) {
      _talker.debug(content);
    }
  }

  void w(Object content) {
    if (!kReleaseMode) {
      _talker.warning(content);
    }
  }

  void i(Object content) {
    if (!kReleaseMode) {
      _talker.info(content);
    }
  }

  void e(Object content) {
    if (!kReleaseMode) {
      _talker.error(content);
    }
  }

  void v(Object content) {
    if (!kReleaseMode) {
      _talker.verbose(content);
    }
  }

  void dispose() {}
}
