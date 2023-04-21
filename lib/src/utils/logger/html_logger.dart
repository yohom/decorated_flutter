import 'package:dio/dio.dart';
import 'package:flutter/foundation.dart';
import 'package:talker/talker.dart';

import 'logger.dart';

class Logger implements ILogger {
  final _talker = Talker();

  /// 初始化日志
  @override
  Future<void> init({bool withFileLogger = true}) async {
    // do nothing
  }

  /// 日志所在路径
  @override
  String get logDir => 'invalid';

  @override
  void d(Object content) {
    if (!kReleaseMode) {
      _talker.debug(content);
    }
  }

  @override
  void w(Object content) {
    if (!kReleaseMode) {
      _talker.warning(content);
    }
  }

  @override
  void i(Object content) {
    if (!kReleaseMode) {
      _talker.info(content);
    }
  }

  @override
  void e(Object content) {
    if (!kReleaseMode) {
      _talker.error(content);
    }
  }

  @override
  void v(Object content) {
    if (!kReleaseMode) {
      _talker.verbose(content);
    }
  }

  @override
  void dispose() {}

  @override
  Interceptor get dioLogger {
    return kReleaseMode
        ? const Interceptor()
        : LogInterceptor(
            error: true,
            request: true,
            requestBody: true,
            requestHeader: true,
            responseBody: true,
            responseHeader: true,
          );
  }
}
