@Deprecated('统一使用io_logger')
library html_logger;

import 'package:dio/dio.dart';
import 'package:flutter/foundation.dart';
import 'package:talker_flutter/talker_flutter.dart';

import 'logger.dart';

class Logger extends ILogger {
  final _talker = TalkerFlutter.init(
    settings: TalkerSettings(
      enabled: !kReleaseMode,
    ),
  );

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
