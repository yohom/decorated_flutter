part of '../base.dart';

/// 只输入数据的业务单元
class OptionalInput<T> extends Input<T?> {
  OptionalInput({
    super.seedValue,
    required super.semantics,
    super.sync,
    super.isBehavior,
    super.printLog,
    super.acceptEmpty,
    super.isDistinct,
    super.onReset,
    super.persistConfig,
  });
}

/// 只输出数据的业务单元
class OptionalOutput<T, ARG> extends Output<T?, ARG> {
  OptionalOutput({
    super.seedValue,
    required super.semantics,
    super.sync = true,
    super.printLog = true,
    super.isBehavior = true,
    required super.fetch,
    super.onReset,
    super.persistConfig,
    super.skipError,
  }) {
    stream = _subject.stream;
  }
}

/// 转发上游流的业务单元
class OptionalStreamOutput<T> extends StreamOutput<T?> {
  OptionalStreamOutput(
    super.source, {
    super.seedValue,
    required super.semantics,
    super.sync = true,
    super.printLog = true,
    super.isBehavior = true,
    super.onReset,
    super.persistConfig,
    super.skipError,
  });
}

/// 既可以输入又可以输出的事件
class OptionalIO<T> extends IO<T?> {
  OptionalIO({
    super.seedValue,
    required String semantics,
    super.sync,
    super.isBehavior,
    super.acceptEmpty,
    super.isDistinct,
    super.printLog,
    FetchCallback<T, dynamic>? fetch,
    super.onReset,
    super.persistConfig,
  }) : super(semantics: semantics) {
    stream = _subject.stream;

    _fetch = fetch ??
        (_) => throw '[$semantics] 在未设置fetch回调时调用了update方法, 请检查业务逻辑是否正确!';
  }
}
