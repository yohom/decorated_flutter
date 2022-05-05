part of '../base.dart';

/// 只接收int类型数据的IO
class IntIO extends IO<int> with IntMixin {
  IntIO({
    required int seedValue,
    required String semantics,
    bool sync = true,
    bool isBehavior = true,
    bool acceptEmpty = true,
    bool isDistinct = false,
    bool printLog = true,
    int? min,
    int? max,
    int? remainder,
    _FetchCallback<int, dynamic>? fetch,
    int Function()? onReset,
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
        ) {
    _min = min;
    _max = max;
    _remainder = remainder;
  }
}

/// 只接收int类型数据的Input
class IntInput extends Input<int> with IntMixin {
  IntInput({
    required int seedValue,
    required String semantics,
    bool sync = true,
    bool isBehavior = true,
    bool acceptEmpty = true,
    bool isDistinct = false,
    int? min,
    int? max,
    int? remainder,
    bool printLog = true,
    int Function()? onReset,
    String? persistentKey,
  }) : super(
          seedValue: seedValue,
          semantics: semantics,
          sync: sync,
          isBehavior: isBehavior,
          acceptEmpty: acceptEmpty,
          isDistinct: isDistinct,
          printLog: printLog,
          onReset: onReset,
          persistentKey: persistentKey,
        ) {
    _min = min;
    _max = max;
    _remainder = remainder;
  }
}

mixin IntMixin on BaseIO<int> {
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
      result = (latest + value).remainder(_remainder!);
      if (_min != null) {
        result = math.max(_min!, result);
      }
    } else if (_max != null) {
      result = math.min(latest + value, _max!);
    } else {
      result = latest + value;
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
      result = (latest - value).remainder(_remainder!);
      if (_min != null) {
        result = math.max(_min!, result);
      }
    } else if (_min != null) {
      result = math.max(latest - value, _min!);
    } else {
      result = latest - value;
    }
    _subject.add(result);
    return result;
  }

  Stream<String> mapToString([String Function(int)? mapper]) {
    return map((event) => mapper != null ? mapper(event) : '$event');
  }
}
