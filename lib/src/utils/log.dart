import 'dart:async';
import 'dart:io';

import 'package:flutter/foundation.dart';
import 'package:flutter_mxlogger/flutter_mxlogger.dart';

final _Logger L = _Logger();

class _Logger {
  late final MXLogger _logger;

  /// 初始化日志
  Future<void> init() async {
    if (!kIsWeb) {
      _logger = await MXLogger.initialize(
        nameSpace: "me.yohom.decorated_flutter",
        storagePolicy: "yyyy_MM_dd",
      );
      _logger.setMaxDiskAge(60 * 60 * 24 * 7); // one week
      _logger.setMaxDiskSize(1024 * 1024 * 10); // 10M
      _logger.setFileLevel(1);
      _logger.setConsoleEnable(!kReleaseMode);
    }
  }

  /// 日志所在路径
  Directory get logDir => Directory(_logger.diskcachePath);

  void d(Object content) {
    if (kIsWeb) {
      debugPrint(content.toString());
    } else {
      _logger.debug(content.toString());
    }
  }

  void w(Object content) {
    if (kIsWeb) {
      debugPrint(content.toString());
    } else {
      _logger.warn(content.toString());
    }
  }

  void i(Object content) {
    if (kIsWeb) {
      debugPrint(content.toString());
    } else {
      _logger.info(content.toString());
    }
  }

  void e(Object content) {
    if (kIsWeb) {
      debugPrint(content.toString());
    } else {
      _logger.error(content.toString());
    }
  }

  void v(Object content) {
    if (kIsWeb) {
      debugPrint(content.toString());
    } else {
      _logger.debug(content.toString());
    }
  }

  /// 写日志到文件
  ///
  /// 清理[evict]时长前的文件.
  @Deprecated('直接使用其他方法即可')
  void file(
    Object content, {
    Duration evict = const Duration(days: 7),
    @Deprecated('使用forward代替') bool logConsole = true,
    void Function(String)? forward,
    String? tag,
  }) async {
    i(content);
  }

  void dispose() {}
}
