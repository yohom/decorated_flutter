import 'package:dio/dio.dart';

import 'io_logger.dart' if (dart.library.html) 'html_logger.dart';

final Logger L = Logger();

abstract class ILogger {
  /// 初始化日志
  Future<void> init({bool withFileLogger = true});

  /// 日志所在路径
  String get logDir;

  void d(Object content);

  void w(Object content);

  void i(Object content);

  void e(Object content);

  void v(Object content);

  void dispose();

  Interceptor get dioLogger;
}
