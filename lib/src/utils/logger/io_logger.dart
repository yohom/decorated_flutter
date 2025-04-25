import 'package:decorated_flutter/decorated_flutter.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:talker_dio_logger/talker_dio_logger.dart';
import 'package:talker_flutter/talker_flutter.dart';

final _kDivider = '\n${'-' * 100}\n';

class Logger extends ILogger {
  final _talker = TalkerFlutter.init(
    settings: TalkerSettings(
      enabled: !kReleaseMode,
    ),
  );

  String get _context {
    try {
      final stackTrace = StackTrace.current;
      final callerFrame = stackTrace.toString().split('\n')[2];
      final classMethodName =
          callerFrame.substring(8).substringBeforeLast('(').trim();
      return '[$classMethodName]';
    } catch (_) {
      return '[unknown]';
    }
  }

  @override
  void d(Object content) {
    _talker.debug('$_context$_kDivider$content');
  }

  @override
  void w(Object content) {
    _talker.warning('$_context$_kDivider$content');
  }

  @override
  void i(Object content) {
    _talker.info('$_context$_kDivider$content');
  }

  @override
  void e(Object content) {
    _talker.error('$_context$_kDivider$content');
  }

  @override
  void v(Object content) {
    _talker.verbose('$_context$_kDivider$content');
  }

  @override
  void openPanel() {
    gNavigatorKey.currentState?.push(
      MaterialPageRoute(
        builder: (_) => AnnotatedRegion(
          value: SystemUiOverlayStyle.light,
          child: TalkerScreen(talker: _talker),
        ),
      ),
    );
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
}
