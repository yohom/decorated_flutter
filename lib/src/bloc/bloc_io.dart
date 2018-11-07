import 'package:flutter/material.dart';
import 'package:framework/framework.dart';
import 'package:meta/meta.dart';
import 'package:rxdart/rxdart.dart';

typedef bool _Equal<T>(T data1, T data2);
typedef Future<T> _Trigger<T>();

abstract class BaseIO<T> {
  BaseIO({
    /// 初始值, 传递给内部的[subject]
    this.seedValue,

    /// Event代表的语义
    this.semantics,

    /// 是否同步发射数据, 传递给内部的[subject]
    bool sync = true,

    /// 是否使用BehaviorSubject, 如果使用, 那么Event内部的[subject]会保存最近一次的值
    /// 默认为false
    bool isBehavior = false,
  }) {
    subject = isBehavior
        ? BehaviorSubject<T>(seedValue: seedValue, sync: sync)
        : PublishSubject<T>(sync: sync);

    subject.listen((data) {
      latest = data;
      L.p('当前${semantics ??= data.runtimeType.toString()} latest: $latest'
          '\n++++++++++++++++++++++++++++++++++++++++++++++++++++++++');
    });

    latest = seedValue;
  }

  /// 最新的值
  T latest;

  /// 初始值
  @protected
  T seedValue;

  /// 语义
  @protected
  String semantics;

  /// 内部中转对象
  @protected
  Subject<T> subject;

  void addError(Object error, [StackTrace stackTrace]) {
    subject.addError(error, stackTrace);
  }

  Observable<S> map<S>(S convert(T event)) {
    return subject.map(convert);
  }

  Observable<T> where(bool test(T event)) {
    return subject.where(test);
  }

  /// 清理保存的值, 恢复成初始状态
  void clear() {
    L.p('----------------------------------------------------------------\n'
        '${semantics ??= runtimeType.toString()}事件 cleared '
        '\n----------------------------------------------------------------');
    latest = seedValue;
    subject.add(seedValue);
  }

  /// 关闭流
  void dispose() {
    L.p('==============================================================\n'
        '${semantics ??= runtimeType.toString()}事件 disposed '
        '\n==============================================================');
    subject.close();
  }

  /// 运行时概要
  String runtimeSummary() {
    return '$semantics:\n\t\tseedValue: $seedValue,\n\t\tlatest: $latest';
  }

  @override
  String toString() {
    return 'Output{latest: $latest, seedValue: $seedValue, semantics: $semantics, subject: $subject}';
  }
}

class Input<T> extends BaseIO<T> with InputMixin {
  Input({
    T seedValue,
    String semantics,
    bool sync = true,
    bool isBehavior = false,
    bool acceptEmpty = false,
    bool isDistinct = true,
    _Equal test,
  }) : super(
          seedValue: seedValue,
          semantics: semantics,
          sync: sync,
          isBehavior: isBehavior,
        ) {
    this._acceptEmpty = acceptEmpty;
    this._isDistinct = isDistinct;
    this._test = test;
  }
}

/// 只输出数据的业务单元
class Output<T> extends BaseIO<T> with OutputMixin {
  Output({
    T seedValue,
    String semantics,
    bool sync = true,
    bool isBehavior = false,
    @required _Trigger<T> trigger,
  }) : super(
          seedValue: seedValue,
          semantics: semantics,
          sync: sync,
          isBehavior: isBehavior,
        ) {
    stream = subject.stream;
    _trigger = trigger;
  }
}

/// 既可以输入又可以输出的事件
class IO<T> extends BaseIO<T> with InputMixin, OutputMixin {
  // IO不需要trigger
  IO({
    T seedValue,
    String semantics,
    bool sync = true,
    bool isBehavior = false,
    bool acceptEmpty = false,
    bool isDistinct = true,
    _Equal test,
    _Trigger<T> trigger,
  }) : super(
          seedValue: seedValue,
          semantics: semantics,
          sync: sync,
          isBehavior: isBehavior,
        ) {
    stream = subject.stream;

    _acceptEmpty = acceptEmpty;
    _isDistinct = isDistinct;
    _test = test;
    _trigger = trigger;
  }
}

mixin InputMixin<T> on BaseIO<T> {
  bool _acceptEmpty;
  bool _isDistinct;
  _Equal _test;

  void add(T data) {
    L.p('++++++++++++++++++++++++++++++++++++++++++++++++++++++++\n'
        'IO接收到**${semantics ??= data.runtimeType.toString()}**数据: $data');

    if (isEmpty(data) && !_acceptEmpty) {
      return;
    }

    // 如果需要distinct的话, 就判断是否相同; 如果不需要distinct, 直接发射数据
    if (_isDistinct) {
      // 如果是不一样的数据, 才发射新的通知,防止TabBar的addListener那种
      // 不停地发送通知(但是值又是一样)的情况
      if (_test != null) {
        if (!_test(latest, data)) {
          L.p('IO转发出**${semantics ??= data.runtimeType.toString()}**数据: $data');
          subject.add(data);
        } else {
          L.p('转发被拒绝!');
        }
      } else {
        if (data != latest) {
          L.p('IO转发出**${semantics ??= data.runtimeType.toString()}**数据: $data');
          subject.add(data);
        } else {
          L.p('转发被拒绝!');
        }
      }
    } else {
      L.p('IO转发出**${semantics ??= data.runtimeType.toString()}**数据: $data');
      subject.add(data);
    }
  }

  void addIfAbsent(T data) {
    // 如果最新值是_seedValue或者是空, 那么才add新数据, 换句话说, 就是如果event已经被add过
    // 了的话那就不add了, 用于第一次add
    if (seedValue == latest || isEmpty(latest)) {
      add(data);
    }
  }
}

mixin OutputMixin<T> on BaseIO<T> {
  /// 输出Future
  Future<T> get future => stream.first;

  /// 输出Stream
  Observable<T> stream;

  void listen(
    ValueChanged<T> listener, {
    Function onError,
    VoidCallback onDone,
    bool cancelOnError,
  }) {
    stream.listen(
      listener,
      onError: onError,
      onDone: onDone,
      cancelOnError: cancelOnError,
    );
  }

  /// 输出Stream
  _Trigger<T> _trigger;

  /// 使用内部的trigger获取数据
  Future<T> update() {
    return _trigger()..then(subject.add);
  }
}
