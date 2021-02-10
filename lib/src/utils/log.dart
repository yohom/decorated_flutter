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
  /// 清理[evict]时长前的文件
  void file(Object content, {Duration evict = const Duration(days: 7)}) async {
    _cacheDir ??= await getTemporaryDirectory();
    final logDir = Directory('${_cacheDir.path}/log');
    // 清理keep前的日志文件
    logDir
        .list()
        .where((file) =>
            file.statSync().changed.isBefore(DateTime.now().subtract(evict)))
        .listen((file) => file.delete());

    final time = DateTime.now();
    final log = File('${_cacheDir.path}/log/${time.format('yyyy-MM-dd')}.txt');
    if (log.existsSync()) {
      log.writeAsString(
        '${time.format('H:m:s')}: $content\n',
        mode: FileMode.append,
      );
    } else {
      log.createSync(recursive: true);
      log.writeAsString(
        '${time.format('H:m:s')}: $content\n',
        mode: FileMode.append,
      );
    }
  }
}
