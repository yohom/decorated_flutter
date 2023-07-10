import 'package:dio/dio.dart';

import 'io_logger.dart';

final Logger L = Logger();

abstract class ILogger {
  /// 初始化日志
  Future<void> init({bool withFileLogger = true}) async {}

  /// 日志所在路径
  String get logDir => throw '暂未支持文件系统日志';

  void d(Object content);

  void w(Object content);

  void i(Object content);

  void e(Object content);

  void v(Object content);

  /// 打开日志面板
  void openPanel() {}

  void dispose() {}

  Interceptor get dioLogger;
}
