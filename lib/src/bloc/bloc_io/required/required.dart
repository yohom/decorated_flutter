part of '../base.dart';

/// 只输入数据的业务单元
class Input<T> extends BaseIO<T> with InputMixin<T> {
  Input({
    required super.seedValue,
    required super.semantics,
    super.sync,
    super.isBehavior,
    super.printLog,
    bool acceptEmpty = true,
    bool isDistinct = false,
    super.onReset,
    bool Function(T, T)? isSame,
    super.persistConfig,
  }) {
    _acceptEmpty = acceptEmpty;
    _isDistinct = isDistinct;
    _isSame = isSame ?? (a, b) => a == b;
  }

  static OptionalInput<T> optional<T>({
    T? seedValue,
    required String semantics,
    bool sync = true,
    bool isBehavior = true,
    bool printLog = true,
    bool acceptEmpty = true,
    bool isDistinct = false,
    T? Function()? onReset,
    PersistConfig<T>? persistConfig,
  }) {
    return OptionalInput<T>(
      semantics: semantics,
      seedValue: seedValue,
      sync: sync,
      isBehavior: isBehavior,
      printLog: printLog,
      acceptEmpty: acceptEmpty,
      isDistinct: isDistinct,
      onReset: onReset,
      persistConfig: persistConfig,
    );
  }
}

/// 转发上游流的业务单元
class StreamOutput<T> extends BaseIO<T> with OutputMixin<T, void> {
  static OptionalStreamOutput<T> optional<T>(
    final Stream<T> source, {
    T? seedValue,
    required String semantics,
    bool sync = true,
    bool printLog = true,
    bool isBehavior = true,
    T? Function()? onReset,
    PersistConfig<T?>? persistConfig,
    bool skipError = false,
  }) {
    return OptionalStreamOutput<T>(
      source,
      semantics: semantics,
      seedValue: seedValue,
      sync: sync,
      isBehavior: isBehavior,
      printLog: printLog,
      onReset: onReset,
      persistConfig: persistConfig,
      skipError: skipError,
    );
  }

  StreamOutput(
    final Stream<T> source, {
    required super.seedValue,
    required super.semantics,
    super.sync = true,
    super.printLog = true,
    super.isBehavior = true,
    super.onReset,
    super.persistConfig,
    super.skipError,
  }) {
    _sourceSubscription = source.listen(_subject.add);
    stream = _subject.stream;
    _onUpdate = (_) => throw 'StreamOutput不应调用update方法!\n${StackTrace.current}';
  }

  late final StreamSubscription<T> _sourceSubscription;

  @override
  void dispose() {
    _sourceSubscription.cancel();
    super.dispose();
  }
}

/// 只输出数据的业务单元
class Output<T, ARG> extends BaseIO<T> with OutputMixin<T, ARG> {
  Output({
    required super.seedValue,
    required super.semantics,
    super.sync = true,
    super.printLog = true,
    super.isBehavior = true,
    required OnUpdateCallback<T, ARG?> onUpdate,
    super.onReset,
    super.persistConfig,
    super.skipError,
  }) {
    stream = _subject.stream;
    _onUpdate = onUpdate;
  }

  static OptionalOutput<T, ARG> optional<T, ARG>({
    T? seedValue,
    required String semantics,
    bool sync = true,
    bool printLog = true,
    bool isBehavior = true,
    required OnUpdateCallback<T, ARG?> onUpdate,
    T? Function()? onReset,
    PersistConfig<T?>? persistConfig,
    bool skipError = false,
  }) {
    return OptionalOutput<T, ARG>(
      semantics: semantics,
      seedValue: seedValue,
      sync: sync,
      isBehavior: isBehavior,
      printLog: printLog,
      onUpdate: onUpdate,
      onReset: onReset,
      persistConfig: persistConfig,
      skipError: skipError,
    );
  }
}

/// 既可以输入又可以输出的事件
class IO<T> extends BaseIO<T> with InputMixin<T>, OutputMixin<T, dynamic> {
  IO({
    required super.seedValue,
    required String semantics,
    super.sync,
    super.isBehavior,
    bool acceptEmpty = true,
    bool isDistinct = false,
    bool Function(T, T)? isSame,
    super.printLog,
    OnUpdateCallback<T, dynamic>? onUpdate,
    super.onReset,
    super.persistConfig,
  }) : super(
          semantics: semantics,
        ) {
    stream = _subject.stream;

    _acceptEmpty = acceptEmpty;
    _isDistinct = isDistinct;
    if (isSame != null) _isSame = isSame;
    _onUpdate = onUpdate ??
        (_) =>
            throw '[$semantics]在未设置onUpdate回调时调用了update方法, 请检查逻辑是否正确!\n${StackTrace.current}';
  }

  static OptionalIO<T> optional<T>({
    T? seedValue,
    required String semantics,
    bool sync = true,
    bool isBehavior = true,
    bool acceptEmpty = true,
    bool isDistinct = false,
    bool printLog = true,
    OnUpdateCallback<T, dynamic>? fetch,
    T? Function()? onReset,
    PersistConfig<T?>? persistConfig,
  }) {
    return OptionalIO<T>(
      semantics: semantics,
      seedValue: seedValue,
      sync: sync,
      isBehavior: isBehavior,
      acceptEmpty: acceptEmpty,
      printLog: printLog,
      isDistinct: isDistinct,
      fetch: fetch,
      onReset: onReset,
      persistConfig: persistConfig,
    );
  }
}

/// 输入单元特有的成员
///
/// 泛型[T]为数据数据的类型
mixin InputMixin<T> on BaseIO<T> {
  bool _acceptEmpty = true;
  bool _isDistinct = false;
  // ignore: prefer_function_declarations_over_variables
  bool Function(T, T) _isSame = (a, b) => a == b;

  /// 发射数据
  T? add(T data) {
    if (_subject.isClosed) {
      L.w('[DECORATED_FLUTTER] [$_semantics]IO在close状态下请求发送数据');
      return null;
    }

    if (isEmpty(data) && !_acceptEmpty) {
      if (_printLog) {
        L.w('[DECORATED_FLUTTER] [$_semantics]转发被拒绝! 原因: 需要非Empty值, 但是接收到Empty值');
      }
      return data;
    }

    // 如果需要distinct的话, 就判断是否相同; 如果不需要distinct, 直接发射数据
    if (_isDistinct) {
      // 如果是不一样的数据, 才发射新的通知,防止TabBar的addListener那种
      // 不停地发送通知(但是值又是一样)的情况
      if (!_isSame(data, latest)) {
        if (_printLog) L.d('[DECORATED_FLUTTER] IO转发出[$_semantics]数据: $data');
        _subject.add(data);
      } else {
        if (_printLog) {
          L.w('[DECORATED_FLUTTER] [$_semantics]转发被拒绝! 原因: 需要唯一, 但是新数据 ($data) 与最新值 ($latest) 相同');
        }
      }
    } else {
      if (_printLog) L.d('[DECORATED_FLUTTER] IO转发出[$_semantics]数据: $data');
      _subject.add(data);
    }

    return data;
  }

  T? addIfAbsent(T data) {
    if (_subject.isClosed) {
      L.w('[DECORATED_FLUTTER] [$_semantics]IO在close状态下请求发送数据');
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
/// 泛型[T]为输出数据的类型, 泛型[ARG]为请求数据时的参数类型. 一般参数只有一个时, 就
/// 直接使用该参数的类型, 如果有多个时, 就使用List接收.
mixin OutputMixin<T, ARG> on BaseIO<T> {
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
      final subscription = stream.listen((data) {
        if (_subject.isClosed) {
          completer
              .completeError(StateError('IO [$_semantics] 已被释放, 不能获取first值'));
        } else {
          completer.complete(data);
        }
      });
      final result = await completer.future.whenComplete(subscription.cancel);
      return result;
    }
  }

  /// 输出Stream
  late Stream<T> stream;

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

  /// 输出Stream
  late OnUpdateCallback<T, ARG?> _onUpdate;

  /// 使用内部的trigger获取数据
  Future<T> update([ARG? arg]) async {
    return _onUpdate(arg).apply((data) {
      if (!_subject.isClosed) _subject.add(data);
    }).catchError((error) {
      if (!_subject.isClosed && !_skipError) _subject.addError(error);
      // 这里不知道这样处理合不合适
      return null as T;
    });
  }
}
