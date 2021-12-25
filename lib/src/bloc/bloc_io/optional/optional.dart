part of '../base.dart';

/// 只输入数据的业务单元
class OptionalInput<T> extends Input<T?> {
  @Deprecated('使用Input.optional代替')
  OptionalInput({
    T? seedValue,
    required String semantics,
    bool sync = true,
    bool isBehavior = true,
    bool printLog = true,
    bool acceptEmpty = true,
    bool isDistinct = false,
    T? Function()? onReset,
    String? persistentKey,
  }) : super(
          seedValue: seedValue,
          semantics: semantics,
          sync: sync,
          isBehavior: isBehavior,
          onReset: onReset,
          acceptEmpty: acceptEmpty,
          isDistinct: isDistinct,
          persistentKey: persistentKey,
          printLog: printLog,
        );
}

/// 只输出数据的业务单元
class OptionalOutput<T, ARG> extends Output<T?, ARG> {
  @Deprecated('使用Output.optional代替')
  OptionalOutput({
    T? seedValue,
    required String semantics,
    bool sync = true,
    bool printLog = true,
    bool isBehavior = true,
    required _FetchCallback<T, ARG?> fetch,
    T? Function()? onReset,
    String? persistentKey,
  }) : super(
          seedValue: seedValue,
          semantics: semantics,
          sync: sync,
          fetch: fetch,
          isBehavior: isBehavior,
          onReset: onReset,
          printLog: printLog,
          persistentKey: persistentKey,
        ) {
    stream = _subject.stream;
  }
}

/// 既可以输入又可以输出的事件
class OptionalIO<T> extends IO<T?> {
  @Deprecated('使用IO.optional代替')
  OptionalIO({
    T? seedValue,
    required String semantics,
    bool sync = true,
    bool isBehavior = true,
    bool acceptEmpty = true,
    bool isDistinct = false,
    bool printLog = true,
    _FetchCallback<T, dynamic>? fetch,
    T? Function()? onReset,
    String? persistentKey,
  }) : super(
          seedValue: seedValue,
          semantics: semantics,
          sync: sync,
          isBehavior: isBehavior,
          onReset: onReset,
          acceptEmpty: acceptEmpty,
          isDistinct: isDistinct,
          persistentKey: persistentKey,
          printLog: printLog,
        ) {
    stream = _subject.stream;

    _fetch = fetch ??
        (_) => throw '[$semantics] 在未设置fetch回调时调用了update方法, 请检查业务逻辑是否正确!';
  }
}
