import 'dart:io';

import 'package:decorated_flutter/decorated_flutter.dart';
import 'package:flutter_mxlogger/flutter_mxlogger.dart';
import 'package:talker/talker.dart';
import 'package:talker_dio_logger/talker_dio_logger.dart';

class Logger {
  MXLogger? _logger;
  final _talker = Talker();

  /// 初始化日志
  Future<void> init() async {
    // 文件日志
    if (Platform.isAndroid || Platform.isIOS) {
      _logger = await MXLogger.initialize(
        nameSpace: "me.yohom.decorated_flutter",
        storagePolicy: MXStoragePolicyType.yyyy_MM_dd,
      );
      _logger!.setMaxDiskAge(60 * 60 * 24 * 7); // one week
      _logger!.setMaxDiskSize(1024 * 1024 * 10); // 10M
      _logger!.setFileLevel(1);
      _logger!.setConsoleEnable(false); // 控制台打印一律使用talker
    }
  }

  /// 日志所在路径
  Directory get logDir {
    return _logger == null
        ? Directory('invalid')
        : Directory(_logger!.diskcachePath);
  }

  void d(Object content) {
    _logger?.debug(content.toString());
    _talker.debug(content);
  }

  void w(Object content) {
    _logger?.warn(content.toString());
    _talker.warning(content);
  }

  void i(Object content) {
    _logger?.info(content.toString());
    _talker.info(content);
  }

  void e(Object content) {
    _logger?.error(content.toString());
    _talker.error(content);
  }

  void v(Object content) {
    _logger?.debug(content.toString());
    _talker.verbose(content);
  }

  Interceptor get dioLogger {
    return TalkerDioLogger(
      settings: const TalkerDioLoggerSettings(
        printRequestHeaders: true,
        printResponseHeaders: true,
        printResponseMessage: true,
        printRequestData: true,
        printResponseData: true,
      ),
    );
  }

  void dispose() {}
}
