part of '../base.dart';

/// 只接收int类型数据的IO
class OptionalIntIO extends IO<int?> with OptionalIntMixin {
  OptionalIntIO({
    int? seedValue,
    required String semantics,
    bool sync = true,
    bool isBehavior = true,
    bool acceptEmpty = true,
    bool isDistinct = false,
    bool printLog = true,
    int? min,
    int? max,
    int? remainder,
    FetchCallback<int, dynamic>? fetch,
    int? Function()? onReset,
    PersistConfig<int?>? persistConfig,
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
        ) {
    _min = min;
    _max = max;
    _remainder = remainder;
  }
}

/// 只接收int类型数据的Input
class OptionalIntInput extends Input<int?> with OptionalIntMixin {
  OptionalIntInput({
    int? seedValue,
    required String semantics,
    bool sync = true,
    bool isBehavior = true,
    bool acceptEmpty = true,
    bool isDistinct = false,
    int? min,
    int? max,
    int? remainder,
    bool printLog = true,
    int? Function()? onReset,
    PersistConfig<int?>? persistConfig,
  }) : super(
          seedValue: seedValue,
          semantics: semantics,
          sync: sync,
          isBehavior: isBehavior,
          acceptEmpty: acceptEmpty,
          isDistinct: isDistinct,
          printLog: printLog,
          onReset: onReset,
          persistConfig: persistConfig,
        ) {
    _min = min;
    _max = max;
    _remainder = remainder;
  }
}

mixin OptionalIntMixin on BaseIO<int?> {
  int? _min;
  int? _max;
  int? _remainder;

  /// 加一个值 并发射
  int? plus([int value = 1]) {
    if (_subject.isClosed) {
      L.w('IO在close状态下请求发送数据');
      return null;
    }

    int result;
    if (_remainder != null) {
      result = (latest! + value).remainder(_remainder!);
      if (_min != null) {
        result = math.max(_min!, result);
      }
    } else if (_max != null) {
      result = math.min(latest! + value, _max!);
    } else {
      result = latest! + value;
    }
    if (!_subject.isClosed) {
      _subject.add(result);
    }
    return result;
  }

  /// 减一个值 并发射
  int? minus([int value = 1]) {
    if (_subject.isClosed) {
      L.w('IO在close状态下请求发送数据');
      return null;
    }

    int result;
    if (_remainder != null) {
      result = (latest! - value).remainder(_remainder!);
      if (_min != null) {
        result = math.max(_min!, result);
      }
    } else if (_min != null) {
      result = math.max(latest! - value, _min!);
    } else {
      result = latest! - value;
    }
    _subject.add(result);
    return result;
  }
}
