import 'dart:async';
import 'dart:io';

import 'package:decorated_flutter/src/utils/utils.export.dart';
import 'package:flutter/foundation.dart';
import 'package:logger/logger.dart';
import 'package:package_info_plus/package_info_plus.dart';
import 'package:path_provider/path_provider.dart';

import '../extension/extension.export.dart';

final _Logger L = _Logger();

class _Logger {
  final logger = Logger();

  Directory? _logDir;
  File? _logFile;
  PackageInfo? _packageInfo;
  late StreamSubscription _logSubscription;
  final _logBuffer = StringBuffer();

  _Logger() {
    _logSubscription = Stream.periodic(const Duration(seconds: 1), passthrough)
        .where((_) => _logBuffer.isNotEmpty)
        .listen(_handleFlushLog);
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

  void i(Object content, {LogPrinter? printer}) {
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
    String? tag,
  }) async {
    final tempPath = (await getTemporaryDirectory()).path;
    _packageInfo ??= await PackageInfo.fromPlatform();
    final appName = _packageInfo!.appName;
    final appVersion = _packageInfo!.version;
    _logDir ??= Directory('$tempPath/log/$appName/$appVersion');

    final now = DateTime.now();
    // 清理keep前的日志文件
    if (_logDir!.existsSync() == true) {
      _logDir!
          .list()
          .where((e) => e.statSync().changed.isBefore(now.subtract(evict)))
          .listen((file) => file.deleteIfExists());
    }

    _logFile = File('${_logDir!.path}/${now.format('yyyy-MM-dd')}.txt');
    if (!_logFile!.existsSync()) _logFile!.createSync(recursive: true);

    final body = '[${tag ?? appName}] ${now.format('HH:mm:ss')}: $content';
    _logBuffer.writeln(body);

    if (logConsole) L.d(content);
  }

  void dispose() {
    _logSubscription.cancel();
  }

  void _handleFlushLog(_) {
    _logFile?.writeAsString(_logBuffer.toString(), mode: FileMode.append);
    _logBuffer.clear();
  }
}
