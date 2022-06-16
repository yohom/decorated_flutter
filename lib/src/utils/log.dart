import 'dart:async';
import 'dart:io';

import 'package:decorated_flutter/src/utils/utils.export.dart';
import 'package:flutter/foundation.dart';
import 'package:logger/logger.dart';
import 'package:package_info_plus/package_info_plus.dart';
import 'package:path_provider/path_provider.dart';

import '../extension/extension.export.dart';

typedef ForwardCallback = void Function(String);

final _Logger L = _Logger();

class _Logger {
  final logger = Logger();

  Directory? _logDir;
  File? _logFile;
  PackageInfo? _packageInfo;
  StreamSubscription? _logSubscription;
  final _logBuffer = StringBuffer();

  /// 向外暴露日志文件路径
  String? get logFilePath => _logFile?.path;

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
    @Deprecated('使用forward代替') bool logConsole = true,
    ForwardCallback? forward = _debugLog,
    String? tag,
  }) async {
    _initFileLogIfNeeded();

    final tempPath = (await getTemporaryDirectory()).path;
    _packageInfo ??= await PackageInfo.fromPlatform();
    final appName = _packageInfo!.appName;
    final appVersion = _packageInfo!.version;
    // 日志目录
    _logDir ??= Directory('$tempPath/log/$appName/$appVersion');

    final now = DateTime.now();
    // 清理keep前的日志文件
    if (_logDir!.existsSync() == true) {
      _logDir!
          .list()
          .where((e) => e.statSync().changed.isBefore(now.subtract(evict)))
          .listen((file) => file.deleteIfExists());
    }

    // 如果没有日志文件就创建一个
    _logFile = File('${_logDir!.path}/${now.format('yyyy-MM-dd')}.txt');
    if (!_logFile!.existsSync()) _logFile!.createSync(recursive: true);

    // 写入日志缓存, 定时flush
    final body = '[${tag ?? appName}] ${now.format('HH:mm:ss')}: $content';
    _logBuffer.writeln(body);

    // 如果已经配置forward就直接略过旧版的logConsole了
    if (forward != null) {
      forward(body);
      return;
    }
    // 使用redirect代替logConsole
    if (logConsole) L.d(content);
  }

  void dispose() {
    _logSubscription?.cancel();
    _logSubscription = null;
  }

  /// 没有开启定时flush就开启一下, 因为有可能被dispose
  void _initFileLogIfNeeded() {
    _logSubscription ??=
        Stream.periodic(const Duration(minutes: 1), passthrough)
            .where((_) => _logBuffer.isNotEmpty)
            .listen(_handleFlushLog);
  }

  void _handleFlushLog(_) {
    _logFile?.writeAsString(_logBuffer.toString(), mode: FileMode.append);
    _logBuffer.clear();
  }
}

// 由于对象的方法不能作为参数默认值(不是常量), 这里放一个顶层函数来变通处理一下
void _debugLog(Object content) {
  L.d(content);
}
