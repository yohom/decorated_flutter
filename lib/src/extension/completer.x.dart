import 'dart:async';

import 'package:decorated_flutter/src/utils/logger/logger.dart';

extension CompleterX<T> on Completer<T> {
  /// 安全地完成Completer
  ///
  /// 如果Completer已经完成，则记录警告日志并返回，而不是抛出异常
  void safeComplete([FutureOr<T>? value]) {
    if (isCompleted) {
      L.w('[DECORATED_FLUTTER] Completer已完成, 略过重复complete调用');
      return;
    }
    complete(value);
  }

  /// 安全地以错误完成Completer
  ///
  /// 如果Completer已经完成，则记录警告日志并返回，而不是抛出异常
  void safeCompleteError(Object error, [StackTrace? stackTrace]) {
    if (isCompleted) {
      L.w('[DECORATED_FLUTTER] Completer已完成, 略过重复completeError调用');
      return;
    }
    completeError(error, stackTrace);
  }
}