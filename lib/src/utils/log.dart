import 'package:flutter/foundation.dart';
import 'package:logging/logging.dart';

final _Logger L = _Logger();

class _Logger {
  _Logger() {
    Logger.root.level = Level.ALL; // defaults to Level.INFO
    Logger.root.onRecord.listen((record) {
      debugPrint('${record.level.name}: ${record.time}: ${record.message}');
    });
  }

  final log = Logger('Logger');

  void d(Object content) {
    if (!kReleaseMode) {
      log.fine(content.toString());
    }
  }

  void w(Object content) {
    if (!kReleaseMode) {
      log.warning(content.toString());
    }
  }

  void i(Object content) {
    if (!kReleaseMode) {
      log.info(content.toString());
    }
  }

  void e(Object content) {
    if (!kReleaseMode) {
      log.severe(content.toString());
    }
  }

  /// profile模式打印
  @Deprecated('使用L.d代替')
  void p(Object content) {
    if (!kReleaseMode) {
      log.fine(content.toString());
    }
  }

  /// release模式打印
  @Deprecated('使用L.d代替')
  void r(Object content) {
    log.fine(content.toString());
  }
}
