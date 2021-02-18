import 'dart:io';

import 'package:flutter/foundation.dart';
import 'package:logger/logger.dart';
import 'package:path_provider/path_provider.dart';

import '../extension/extension.export.dart';

final _Logger L = _Logger();

class _Logger {
  final logger = Logger();

  Directory _cacheDir;

  void d(Object content) {
    if (!kReleaseMode) {
      logger.d(content);
    }
  }

  void w(Object content) {
    if (!kReleaseMode) {
      logger.w(content);
    }
  }

  void i(Object content, {LogPrinter printer}) {
    if (!kReleaseMode) {
      logger.i(content);
    }
  }

  void e(Object content) {
    if (!kReleaseMode) {
      logger.e(content);
    }
  }

  /// 写日志到文件
  ///
  /// 清理[evict]时长前的文件. 会缓存一秒内的日志内容, 然后统一写入文件, 减少与文件交互的次数
  void file(
    Object content, {
    Duration evict = const Duration(days: 7),
    bool logConsole = true,
    String tag = 'default',
  }) async {
    _cacheDir ??= await getTemporaryDirectory();
    final now = DateTime.now();
    final logDir = Directory('${_cacheDir.path}/log');
    // 清理keep前的日志文件
    logDir
        .list()
        .where((file) => file.statSync().changed.isBefore(now.subtract(evict)))
        .listen((file) => file.deleteSync());

    final _file = File('${_cacheDir.path}/log/${now.format('yyyy-MM-dd')}.txt');
    if (!_file.existsSync()) _file.createSync();

    final logContent = '[$tag] ${now.format('HH:mm:ss')}: $content';
    _file.writeAsStringSync(logContent);

    if (logConsole) L.d(content);
  }
}
