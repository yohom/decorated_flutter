import 'dart:io';

import 'package:flutter/foundation.dart';
import 'package:flutter_mxlogger/flutter_mxlogger.dart';

class Logger {
  late final MXLogger _logger;

  /// 初始化日志
  Future<void> init() async {
    _logger = await MXLogger.initialize(
      nameSpace: "me.yohom.decorated_flutter",
      storagePolicy: MXStoragePolicyType.yyyy_MM_dd,
    );
    _logger.setMaxDiskAge(60 * 60 * 24 * 7); // one week
    _logger.setMaxDiskSize(1024 * 1024 * 10); // 10M
    _logger.setFileLevel(1);
    _logger.setConsoleEnable(!kReleaseMode);
  }

  /// 日志所在路径
  Directory get logDir => Directory(_logger.diskcachePath);

  void d(Object content) {
    _logger.debug(content.toString());
  }

  void w(Object content) {
    _logger.warn(content.toString());
  }

  void i(Object content) {
    _logger.info(content.toString());
  }

  void e(Object content) {
    _logger.error(content.toString());
  }

  void v(Object content) {
    _logger.debug(content.toString());
  }

  void dispose() {}
}
