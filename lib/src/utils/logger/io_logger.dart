import 'dart:async';

import 'package:decorated_flutter/decorated_flutter.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:talker_dio_logger/talker_dio_logger.dart';
import 'package:talker_flutter/talker_flutter.dart';

import '_log_overlay.widget.dart';

final _kDivider = '\n${'-' * 80}\n';

class Logger extends ILogger {
  late final _talker = TalkerFlutter.init(
    settings: TalkerSettings(enabled: enabled),
  );
  Completer<void>? _overlayCompleter;

  String get _context {
    try {
      final stackTrace = StackTrace.current;
      final callerFrame = stackTrace.toString().split('\n')[2];
      final classMethodName = callerFrame.substring(8).trim();
      return '[$classMethodName]';
    } catch (_) {
      return '[unknown]';
    }
  }

  @override
  void d(Object content) {
    if (!enabled) return;
    _talker.debug('$_context$_kDivider$content');
  }

  @override
  void w(Object content) {
    if (!enabled) return;
    _talker.warning('$_context$_kDivider$content');
  }

  @override
  void i(Object content) {
    if (!enabled) return;
    _talker.info('$_context$_kDivider$content');
  }

  @override
  void e(Object content) {
    if (!enabled) return;
    _talker.error('$_context$_kDivider$content');
  }

  @override
  void v(Object content) {
    if (!enabled) return;
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
  Future<void> openOverlay() {
    final currentCompleter = _overlayCompleter;
    if (currentCompleter != null) return currentCompleter.future;

    final overlay = gNavigatorKey.currentState?.overlay;
    if (overlay == null) return Future.value();

    final completer = Completer<void>();
    late final OverlayEntry entry;
    entry = OverlayEntry(
      builder: (_) => LogOverlay(
        talker: _talker,
        onClose: () {
          entry.remove();
          _overlayCompleter = null;
          completer.complete();
        },
      ),
    );
    _overlayCompleter = completer;
    overlay.insert(entry);
    return completer.future;
  }

  @override
  Interceptor get dioLogger {
    return enabled
        ? TalkerDioLogger(
            talker: _talker,
            settings: const TalkerDioLoggerSettings(
              printRequestHeaders: true,
              printResponseHeaders: true,
              printResponseMessage: true,
              printRequestData: true,
              printResponseData: true,
            ),
          )
        : const Interceptor();
  }

  @override
  NavigatorObserver get navigatorObserver => TalkerRouteObserver(_talker);
}
