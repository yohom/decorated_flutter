// @dart=2.9

import 'dart:io';

import 'package:decorated_flutter/decorated_flutter.dart';
import 'package:flutter/foundation.dart';
import 'package:logger/logger.dart';
import 'package:path_provider/path_provider.dart';

import '../extension/extension.export.dart';

final _Logger L = _Logger();

class _Logger {
  final logger = Logger();

  Directory _logDir;
  File _logFile;
  StringBuffer _logBuffer = StringBuffer();

  _Logger() {
    Stream.periodic(Duration(seconds: 5), passthrough).listen((event) {
      _logFile?.writeAsStringSync(_logBuffer.toString(), mode: FileMode.append);
      _logBuffer.clear();
    });
  }

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
  /// 清理[evict]时长前的文件.
  void file(
    Object content, {
    Duration evict = const Duration(days: 7),
    bool logConsole = true,
    String tag = 'default',
  }) async {
    _logDir ??= Directory('${(await getTemporaryDirectory()).path}/log');
    final now = DateTime.now();
    // 清理keep前的日志文件
    if (_logDir.existsSync()) {
      _logDir
          .list()
          .where((e) => e.statSync().changed.isBefore(now.subtract(evict)))
          .listen((file) => file.deleteIfExists());
    }

    _logFile = File('${_logDir.path}/${now.format('yyyy-MM-dd')}.txt');
    if (!_logFile.existsSync()) _logFile.createSync(recursive: true);

    final logContent = '[$tag] ${now.format('HH:mm:ss')}: $content';
    _logBuffer.writeln(logContent);

    if (logConsole) L.d(content);
  }
}
