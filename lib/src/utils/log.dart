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

  int _currentSecond = 0;
  StringBuffer _contentBuffer = StringBuffer();

  /// 写日志到文件
  ///
  /// 清理[evict]时长前的文件. 会缓存一秒内的日志内容, 然后统一写入文件, 减少与文件交互的次数
  void file(
    Object content, {
    Duration evict = const Duration(days: 7),
    bool logConsole = true,
    String channel = 'default',
  }) async {
    _cacheDir ??= await getTemporaryDirectory();
    final logDir = Directory('${_cacheDir.path}/log');
    // 清理keep前的日志文件
    logDir
        .list()
        .where((file) =>
            file.statSync().changed.isBefore(DateTime.now().subtract(evict)))
        .listen((file) => file.delete(recursive: true));

    final time = DateTime.now();
    final log =
        File('${_cacheDir.path}/log/${time.format('yyyy-MM-dd')}/$channel.txt');
    if (_currentSecond != time.millisecondsSinceEpoch ~/ 1000) {
      if (!log.existsSync()) log.createSync(recursive: true);

      log.writeAsStringSync(
        '${time.format('HH:mm:ss')}: ${_contentBuffer.toString()}',
        mode: FileMode.append,
      );
      _currentSecond = time.millisecondsSinceEpoch ~/ 1000;
      _contentBuffer.clear();
    } else {
      _contentBuffer.writeln(content);
    }

    if (logConsole) L.d(content);
  }
}
