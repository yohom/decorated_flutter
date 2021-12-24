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
    _FetchCallback<bool, dynamic>? fetch,
    bool Function()? onReset,
    String? persistentKey,
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
          persistentKey: persistentKey,
        );
}

/// 只接收bool类型数据的Output
class BoolOutput<ARG_TYPE> extends Output<bool, ARG_TYPE> with BoolMixin {
  BoolOutput({
    required bool seedValue,
    required String semantics,
    bool sync = true,
    bool isBehavior = true,
    bool printLog = true,
    required _FetchCallback<bool, ARG_TYPE?> fetch,
    bool Function()? onReset,
    String? persistentKey,
  }) : super(
          seedValue: seedValue,
          semantics: semantics,
          sync: sync,
          isBehavior: isBehavior,
          fetch: fetch,
          printLog: printLog,
          onReset: onReset,
          persistentKey: persistentKey,
        );
}

mixin BoolMixin on BaseRequiredIO<bool> {
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
