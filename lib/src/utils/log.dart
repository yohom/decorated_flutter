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

  void i(Object content) async {
    // 正常打印
    logger.i(content);

    // 保存到文件
    final tempDir = await getTemporaryDirectory();
    final time = DateTime.now();
    final log = File('${tempDir.path}/log/${time.format('yyyy-MM-dd')}.log');
    if (log.existsSync()) {
      log.writeAsStringSync(
        '${time.format()}:\n$content\n',
        mode: FileMode.append,
      );
    } else {
      log.createSync(recursive: true);
      log.writeAsStringSync(
        '${time.format()}:\n$content\n',
        mode: FileMode.append,
      );
    }
  }

  void e(Object content) {
    if (!kReleaseMode) {
      logger.e(content);
    }
  }
}
