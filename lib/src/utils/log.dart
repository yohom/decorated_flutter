import 'dart:async';
import 'dart:io';

import 'package:flutter/foundation.dart';
import 'package:logger/logger.dart';
import 'package:logger/src/outputs/file_output.dart';
import 'package:package_info_plus/package_info_plus.dart';
import 'package:path_provider/path_provider.dart';

import '../extension/extension.export.dart';

typedef ForwardCallback = void Function(String);

final _Logger L = _Logger();

class _Logger {
  late final Logger _logger;
  Directory? logDir;

  /// 初始化日志
  Future<void> init() async {
    if (kIsWeb) {
      _logger = Logger(printer: PrettyPrinter(printTime: true));
    } else {
      final now = DateTime.now();
      final tempPath = (await getTemporaryDirectory()).path;
      final packageInfo = await PackageInfo.fromPlatform();
      final appName = packageInfo.appName;
      final appVersion = packageInfo.version;
      // 日志目录
      logDir ??= Directory('$tempPath/log/$appName/$appVersion');
      // 如果没有日志文件就创建一个
      final logFile = File('${logDir!.path}/${now.format('yyyy-MM-dd')}.txt');
      if (!logFile.existsSync()) logFile.createSync(recursive: true);

      _logger = Logger(
        printer: PrettyPrinter(printTime: true),
        filter: DevelopmentFilter(),
        output: MultiOutput(
          [ConsoleOutput(), if (!kIsWeb) FileOutput(file: logFile)],
        ),
      );
    }
  }

  void d(Object content) {
    _logger.d(content);
  }

  void w(Object content) {
    _logger.w(content);
  }

  void i(Object content, {LogPrinter? printer}) {
    _logger.i(content);
  }

  void e(Object content) {
    _logger.e(content);
  }

  /// 写日志到文件
  ///
  /// 清理[evict]时长前的文件.
  @Deprecated('直接使用其他方法即可')
  void file(
    Object content, {
    Duration evict = const Duration(days: 7),
    @Deprecated('使用forward代替') bool logConsole = true,
    ForwardCallback? forward = _debugLog,
    String? tag,
  }) async {
    i(content);
  }

  void dispose() {
    _logger.close();
  }
}

// 由于对象的方法不能作为参数默认值(不是常量), 这里放一个顶层函数来变通处理一下
void _debugLog(Object content) {
  L.d(content);
}
