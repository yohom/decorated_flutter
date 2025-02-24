part of '../base.dart';

/// 只接收int类型数据的IO
class OptionalIntIO extends IO<int?> with OptionalIntMixin {
  OptionalIntIO({
    super.seedValue,
    required super.semantics,
    super.sync,
    super.isBehavior,
    super.acceptEmpty,
    super.isDistinct,
    super.printLog,
    int? min,
    int? max,
    int? remainder,
    OnUpdateCallback<int, dynamic>? super.onUpdate,
    super.onReset,
    super.persistConfig,
  }) {
    _min = min;
    _max = max;
    _remainder = remainder;
  }
}

/// 只接收int类型数据的Input
class OptionalIntInput extends Input<int?> with OptionalIntMixin {
  OptionalIntInput({
    super.seedValue,
    required super.semantics,
    super.sync,
    super.isBehavior,
    super.acceptEmpty,
    super.isDistinct,
    int? min,
    int? max,
    int? remainder,
    super.printLog,
    super.onReset,
    super.persistConfig,
  }) {
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
      L.w('[DECORATED_FLUTTER] IO在close状态下请求发送数据');
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
      L.w('[DECORATED_FLUTTER] IO在close状态下请求发送数据');
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
