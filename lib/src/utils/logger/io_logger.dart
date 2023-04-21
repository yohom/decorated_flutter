import 'package:decorated_flutter/decorated_flutter.dart';
import 'package:flutter/foundation.dart';
import 'package:talker/talker.dart';
import 'package:talker_dio_logger/talker_dio_logger.dart';

class Logger implements ILogger {
  final _talker = Talker(settings: TalkerSettings(enabled: !kReleaseMode));

  /// 初始化日志
  @override
  Future<void> init({bool withFileLogger = true}) async {
    // // 文件日志
    // if (withFileLogger) {
    //   if (Platform.isAndroid || Platform.isIOS) {
    //     _logger = await MXLogger.initialize(
    //       nameSpace: "me.yohom.decorated_flutter",
    //       storagePolicy: MXStoragePolicyType.yyyy_MM_dd,
    //     );
    //     _logger!.setMaxDiskAge(60 * 60 * 24 * 7); // one week
    //     _logger!.setMaxDiskSize(1024 * 1024 * 10); // 10M
    //     _logger!.setFileLevel(1);
    //     _logger!.setConsoleEnable(false); // 控制台打印一律使用talker
    //   }
    // }
  }

  /// 日志所在路径
  @override
  String get logDir {
    return 'invalid';
    // return _logger == null ? 'invalid' : _logger!.diskcachePath;
  }

  @override
  void d(Object content) {
    // _logger?.debug(content.toString());
    _talker.debug(content);
  }

  @override
  void w(Object content) {
    // _logger?.warn(content.toString());
    _talker.warning(content);
  }

  @override
  void i(Object content) {
    // _logger?.info(content.toString());
    _talker.info(content);
  }

  @override
  void e(Object content) {
    // _logger?.error(content.toString());
    _talker.error(content);
  }

  @override
  void v(Object content) {
    // _logger?.debug(content.toString());
    _talker.verbose(content);
  }

  @override
  Interceptor get dioLogger {
    return kReleaseMode
        ? const Interceptor()
        : TalkerDioLogger(
            talker: _talker,
            settings: const TalkerDioLoggerSettings(
              printRequestHeaders: true,
              printResponseHeaders: true,
              printResponseMessage: true,
              printRequestData: true,
              printResponseData: true,
            ),
          );
  }

  @override
  void dispose() {}
}
