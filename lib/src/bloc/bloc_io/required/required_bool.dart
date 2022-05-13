part of '../base.dart';

/// 只接收bool类型数据的IO
class BoolIO extends IO<bool> with BoolMixin {
  BoolIO({
    required bool seedValue,
    required String semantics,
    bool sync = true,
    bool isBehavior = true,
    bool acceptEmpty = true,
    bool isDistinct = false,
    bool printLog = true,
    FetchCallback<bool, dynamic>? fetch,
    bool Function()? onReset,
    PersistConfig<bool>? persistConfig,
  }) : super(
          seedValue: seedValue,
          semantics: semantics,
          sync: sync,
          isBehavior: isBehavior,
          acceptEmpty: acceptEmpty,
          isDistinct: isDistinct,
          fetch: fetch,
          printLog: printLog,
          onReset: onReset,
          persistConfig: persistConfig,
        );
}

/// 只接收bool类型数据的Output
class BoolOutput<ARG> extends Output<bool, ARG> with BoolMixin {
  BoolOutput({
    required bool seedValue,
    required String semantics,
    bool sync = true,
    bool isBehavior = true,
    bool printLog = true,
    required FetchCallback<bool, ARG?> fetch,
    bool Function()? onReset,
    PersistConfig<bool>? persistConfig,
  }) : super(
          seedValue: seedValue,
          semantics: semantics,
          sync: sync,
          isBehavior: isBehavior,
          fetch: fetch,
          printLog: printLog,
          onReset: onReset,
          persistConfig: persistConfig,
        );
}

mixin BoolMixin on BaseIO<bool> {
  /// 切换true/false 并发射
  bool? toggle() {
    if (_subject.isClosed) {
      L.w('IO在close状态下请求发送数据');
      return null;
    }

    final toggled = !latest;
    _subject.add(toggled);
    return toggled;
  }
}
