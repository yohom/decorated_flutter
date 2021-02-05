import 'dart:io';

import 'package:flutter/foundation.dart';
import 'package:logger/logger.dart';
import 'package:path_provider/path_provider.dart';

import '../extension/extension.export.dart';

final _Logger L = _Logger();

class _Logger {
  final logger = Logger();

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
}

Future<File> appendLogToFile(Object content) async {
  // 保存到文件
  final tempDir = await getTemporaryDirectory();
  final time = DateTime.now();
  final log = File('${tempDir.path}/log/${time.format('yyyy-MM-dd')}.txt');
  if (log.existsSync()) {
    log.writeAsStringSync(
      '${time.format()}: $content\n',
      mode: FileMode.append,
    );
  } else {
    log.createSync(recursive: true);
    log.writeAsStringSync(
      '${time.format()}: $content\n',
      mode: FileMode.append,
    );
  }
  return log;
}
