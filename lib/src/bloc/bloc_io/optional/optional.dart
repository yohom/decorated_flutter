part of '../base.dart';

/// 业务单元基类
abstract class BaseOptionalIO<T> extends BaseIO<T?> {
  BaseOptionalIO({
    /// 初始值, 传递给内部的[_subject]
    T? seedValue,

    /// Event代表的语义
    required String semantics,

    /// 是否同步发射数据, 传递给内部的[_subject]
    bool sync = true,

    /// 是否打印日志, 有些IO add比较频繁时, 影响日志观看
    bool printLog = true,

    /// 是否使用BehaviorSubject, 如果使用, 那么Event内部的[_subject]会保存最近一次的值
    bool isBehavior = true,

    /// 重置回调方法, 如果设置了, 则调用reset的时候会优先使用此回调的返回值
    T? Function()? onReset,

    /// 持久化的key
    String? persistentKey,
  }) : super(
          seedValue: seedValue,
          semantics: semantics,
          sync: sync,
          printLog: printLog,
          isBehavior: isBehavior,
          onReset: onReset,
          persistentKey: persistentKey,
        );
}

/// 只输入数据的业务单元
class OptionalInput<T> extends BaseOptionalIO<T> with OptionalInputMixin<T> {
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
          persistentKey: persistentKey,
          printLog: printLog,
        ) {
    _acceptEmpty = acceptEmpty;
    _isDistinct = isDistinct;
  }
}

/// 只输出数据的业务单元
class OptionalOutput<T, ARG_TYPE> extends BaseOptionalIO<T?>
    with OptionalOutputMixin<T?, ARG_TYPE> {
  OptionalOutput({
    T? seedValue,
    required String semantics,
    bool sync = true,
    bool printLog = true,
    bool isBehavior = true,
    required _FetchCallback<T, ARG_TYPE?> fetch,
    T? Function()? onReset,
    String? persistentKey,
  }) : super(
          seedValue: seedValue,
          semantics: semantics,
          sync: sync,
          isBehavior: isBehavior,
          onReset: onReset,
          printLog: printLog,
          persistentKey: persistentKey,
        ) {
    stream = _subject.stream;
    _fetch = fetch;
  }
}

/// 既可以输入又可以输出的事件
class OptionalIO<T> extends BaseOptionalIO<T?>
    with OptionalInputMixin<T?>, OptionalOutputMixin<T?, dynamic> {
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
          persistentKey: persistentKey,
          printLog: printLog,
        ) {
    stream = _subject.stream;

    _acceptEmpty = acceptEmpty;
    _isDistinct = isDistinct;
    _fetch = fetch ??
        (_) => throw '[$semantics] 在未设置fetch回调时调用了update方法, 请检查业务逻辑是否正确!';
  }
}

/// 输入单元特有的成员
///
/// 泛型[T]为数据数据的类型
mixin OptionalInputMixin<T> on BaseOptionalIO<T> {
  bool _acceptEmpty = true;
  bool _isDistinct = false;

  /// 发射数据
  T? add(T? data) {
    if (_subject.isClosed) {
      L.w('$_semantics IO在close状态下请求发送数据');
      return null;
    }

    if (isEmpty(data) && !_acceptEmpty) {
      if (_printLog) {
        L.w('转发被拒绝! 原因: 需要非Empty值, 但是接收到Empty值');
      }
      return data;
    }

    // 如果需要distinct的话, 就判断是否相同; 如果不需要distinct, 直接发射数据
    if (_isDistinct) {
      // 如果是不一样的数据, 才发射新的通知,防止TabBar的addListener那种
      // 不停地发送通知(但是值又是一样)的情况
      if (data != latest) {
        if (_printLog) L.d('IO转发出**$_semantics**数据: $data');
        _subject.add(data);
      } else {
        if (_printLog) {
          L.w('转发被拒绝! 原因: 需要唯一, 但是新数据与最新值相同');
        }
      }
    } else {
      if (_printLog) L.d('IO转发出**$_semantics**数据: $data');
      _subject.add(data);
    }

    return data;
  }

  T? addIfAbsent(T data) {
    if (_subject.isClosed) {
      L.w('$_semantics IO在close状态下请求发送数据');
      return null;
    }

    // 如果最新值是_seedValue或者是空, 那么才add新数据, 换句话说, 就是如果event已经被add过
    // 了的话那就不add了, 用于第一次add
    if (_seedValue == latest || isEmpty(latest)) {
      add(data);
    }
    return data;
  }

  Future<T?> addStream(Stream<T> source, {bool cancelOnError = true}) {
    return _subject.addStream(source, cancelOnError: cancelOnError)
        as Future<T?>;
  }
}

/// 输出单元特有的成员
///
/// 泛型[T]为输出数据的类型, 泛型[ARG_TYPE]为请求数据时的参数类型. 一般参数只有一个时, 就
/// 直接使用该参数的类型, 如果有多个时, 就使用List接收.
mixin OptionalOutputMixin<T, ARG_TYPE> on BaseOptionalIO<T> {
  /// 输出Future
  @Deprecated('使用first()方法代替')
  Future<T> get future => first(true);

  /// 输出Future, [cancelSubscription]决定是否取消订阅
  ///
  /// 由于[stream.first]会自动结束流的订阅, 但是又想继续流的话, 就使用这个方法获取Future
  Future<T> first([bool cancelSubscription = false]) async {
    if (cancelSubscription) {
      return stream.first;
    } else {
      final completer = Completer<T>();
      final subscription = stream.listen((e) {
        if (!completer.isCompleted) {
          completer.complete(e);
        }
      });
      final result = await completer.future;
      subscription.cancel();
      return result;
    }
  }

  /// 输出Stream
  late Stream<T> stream;

  /// 请求回调
  late _FetchCallback<T, ARG_TYPE?> _fetch;

  /// 监听流
  StreamSubscription<T> listen(
    ValueChanged<T> listener, {
    Function? onError,
    VoidCallback? onDone,
    bool? cancelOnError,
  }) {
    return stream.listen(
      listener,
      onError: onError,
      onDone: onDone,
      cancelOnError: cancelOnError,
    );
  }

  /// 使用内部的trigger获取数据
  Future<T> update([ARG_TYPE? arg]) {
    return _fetch(arg)
      ..then((data) {
        if (!_subject.isClosed) _subject.add(data);
      })
      ..catchError((error) {
        if (!_subject.isClosed) _subject.addError(error);
      });
  }
}
