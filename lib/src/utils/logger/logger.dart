import 'package:dio/dio.dart';
import 'package:flutter/foundation.dart';

import 'io_logger.dart';

final Logger L = Logger();

abstract class ILogger {
  bool enabled = !kReleaseMode;

  /// 初始化日志
  Future<void> init() async {}

  /// 日志所在路径
  String get logDir => throw '暂未支持文件系统日志';

  void d(Object content);

  void w(Object content);

  void i(Object content);

  void e(Object content);

  void v(Object content);

  /// 打开日志面板
  void openPanel() {}

  /// 以可拖拽浮层打开日志面板
  Future<void> openOverlay() async {}

  void dispose() {}

  Interceptor get dioLogger;
}
