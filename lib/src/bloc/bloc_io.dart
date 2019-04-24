import 'dart:async';

import 'package:decorated_flutter/decorated_flutter.dart';
import 'package:flutter/material.dart';
import 'package:meta/meta.dart';
import 'package:rxdart/rxdart.dart';

typedef bool _Equal<T>(T data1, T data2);
typedef Future<T> _Fetch<T, ARG_TYPE>(ARG_TYPE arg);

/// 业务单元基类
abstract class BaseIO<T> {
  BaseIO({
    /// 初始值, 传递给内部的[_subject]
    T seedValue,

    /// Event代表的语义
    String semantics,

    /// 是否同步发射数据, 传递给内部的[_subject]
    bool sync = true,

    /// 是否使用BehaviorSubject, 如果使用, 那么Event内部的[_subject]会保存最近一次的值
    /// 默认为false
    bool isBehavior = false,
  })  : _semantics = semantics,
        _seedValue = seedValue,
        latest = seedValue,
        _subject = isBehavior
            ? BehaviorSubject<T>.seeded(seedValue, sync: sync)
            : PublishSubject<T>(sync: sync) {
    _subject.listen((data) {
      latest = data;
      L.p('当前${semantics ??= data.runtimeType.toString()} latest: $latest'
          '\n+++++++++++++++++++++++++++END+++++++++++++++++++++++++++++');
    });
  }

  /// 最新的值
  T latest;

  /// 初始值
  @protected
  T _seedValue;

  /// 语义
  @protected
  String _semantics;

  /// 内部中转对象
  @protected
  Subject<T> _subject;

  void addError(Object error, [StackTrace stackTrace]) {
    if (!_subject.isClosed) _subject.addError(error, stackTrace);
  }

  Observable<S> map<S>(S convert(T event)) {
    return _subject.map(convert);
  }

  Observable<T> where(bool test(T event)) {
    return _subject.where(test);
  }

  /// 清理保存的值, 恢复成初始状态
  void clear() {
    L.p('-----------------------------BEGIN---------------------------------\n'
        '${_semantics ??= runtimeType.toString()}事件 cleared '
        '\n------------------------------END----------------------------------');
    if (!_subject.isClosed) _subject.add(_seedValue);
  }

  /// 关闭流
  void dispose() {
    L.p('=============================BEGIN===============================\n'
        '${_semantics ??= runtimeType.toString()}事件 disposed '
        '\n==============================END================================');
    if (!_subject.isClosed) _subject.close();
  }

  /// 运行时概要
  String runtimeSummary() {
    return '$_semantics:\n\t\tseedValue: $_seedValue,\n\t\tlatest: $latest';
  }

  @override
  String toString() {
    return 'Output{latest: $latest, seedValue: $_seedValue, semantics: $_semantics, subject: $_subject}';
  }
}

/// BLoC内的静态值, 也就是供初始化时的值, 之前都是直接写成字段, 这里提供一个类, 保持与IO的一致性
class Static<T> {
  T _content;

  void set(T value) {
    assert(_content == null);
    if (_content != null) {
      throw '';
    }
    _content = value;
  }

  T get() => _content;
}

/// 只输入数据的业务单元
class Input<T> extends BaseIO<T> with InputMixin {
  Input({
    T seedValue,
    String semantics,
    bool sync = true,
    bool isBehavior = false,
    bool acceptEmpty = true,
    bool isDistinct = false,
    _Equal test,
  }) : super(
          seedValue: seedValue,
          semantics: semantics,
          sync: sync,
          isBehavior: isBehavior,
        ) {
    _acceptEmpty = acceptEmpty;
    _isDistinct = isDistinct;
    _test = test;
  }
}

/// 内部数据类型是[List]的输入业务单元
class ListInput<T> extends Input<List<T>> with ListMixin {
  ListInput({
    List<T> seedValue,
    String semantics,
    bool sync = true,
    bool isBehavior = false,
    bool acceptEmpty = true,
    bool isDistinct = false,
    _Equal test,
  }) : super(
          seedValue: seedValue,
          semantics: semantics,
          sync: sync,
          isBehavior: isBehavior,
          acceptEmpty: acceptEmpty,
          isDistinct: isDistinct,
          test: test,
        );
}

/// 只输出数据的业务单元
class Output<T, ARG_TYPE> extends BaseIO<T> with OutputMixin<T, ARG_TYPE> {
  Output({
    T seedValue,
    String semantics,
    bool sync = true,
    bool isBehavior = false,
    @required _Fetch<T, ARG_TYPE> fetch,
  }) : super(
          seedValue: seedValue,
          semantics: semantics,
          sync: sync,
          isBehavior: isBehavior,
        ) {
    stream = _subject.stream;
    _fetch = fetch;
  }
}

/// 内部数据类型是[List]的输出业务单元
class ListOutput<T, ARG_TYPE> extends Output<List<T>, ARG_TYPE> with ListMixin {
  ListOutput({
    List<T> seedValue,
    String semantics,
    bool sync = true,
    bool isBehavior = false,
    @required _Fetch<List<T>, ARG_TYPE> fetch,
  }) : super(
          seedValue: seedValue,
          semantics: semantics,
          sync: sync,
          isBehavior: isBehavior,
          fetch: fetch,
        );
}

/// 既可以输入又可以输出的事件
class IO<T> extends BaseIO<T> with InputMixin, OutputMixin<T, dynamic> {
  IO({
    T seedValue,
    String semantics,
    bool sync = true,
    bool isBehavior = false,
    bool acceptEmpty = true,
    bool isDistinct = false,
    _Equal test,
    _Fetch<T, dynamic> fetch,
  }) : super(
          seedValue: seedValue,
          semantics: semantics,
          sync: sync,
          isBehavior: isBehavior,
        ) {
    stream = _subject.stream;

    _acceptEmpty = acceptEmpty;
    _isDistinct = isDistinct;
    _test = test;
    _fetch = fetch;
  }
}

/// 内部数据类型是[List]的输入输出业务单元
class ListIO<T> extends IO<List<T>> with ListMixin {
  ListIO({
    List<T> seedValue,
    String semantics,
    bool sync = true,
    bool isBehavior = false,
    bool acceptEmpty = true,
    bool isDistinct = false,
    _Equal test,
    _Fetch<List<T>, dynamic> fetch,
  }) : super(
          seedValue: seedValue,
          semantics: semantics,
          sync: sync,
          isBehavior: isBehavior,
          acceptEmpty: acceptEmpty,
          isDistinct: isDistinct,
          test: test,
          fetch: fetch,
        );
}

/// 输入单元特有的成员
mixin InputMixin<T> on BaseIO<T> {
  bool _acceptEmpty;
  bool _isDistinct;
  _Equal _test;

  void add(T data) {
    L.p('+++++++++++++++++++++++++++BEGIN+++++++++++++++++++++++++++++\n'
        'IO接收到**${_semantics ??= data.runtimeType.toString()}**数据: $data');

    if (isEmpty(data) && !_acceptEmpty) {
      L.p('转发被拒绝! 原因: 需要非Empty值, 但是接收到Empty值'
          '\n+++++++++++++++++++++++++++END+++++++++++++++++++++++++++++++');
      return;
    }

    // 如果需要distinct的话, 就判断是否相同; 如果不需要distinct, 直接发射数据
    if (_isDistinct) {
      // 如果是不一样的数据, 才发射新的通知,防止TabBar的addListener那种
      // 不停地发送通知(但是值又是一样)的情况
      if (_test != null) {
        if (!_test(latest, data)) {
          L.p('IO转发出**${_semantics ??= data.runtimeType.toString()}**数据: $data');
          if (!_subject.isClosed) _subject.add(data);
        } else {
          L.p('转发被拒绝! 原因: 需要唯一, 但是没有通过唯一性测试'
              '\n+++++++++++++++++++++++++++END+++++++++++++++++++++++++++++');
        }
      } else {
        if (data != latest) {
          L.p('IO转发出**${_semantics ??= data.runtimeType.toString()}**数据: $data');
          if (!_subject.isClosed) _subject.add(data);
        } else {
          L.p('转发被拒绝! 原因: 需要唯一, 但是新数据与最新值相同'
              '\n+++++++++++++++++++++++++++END+++++++++++++++++++++++++++++');
        }
      }
    } else {
      L.p('IO转发出**${_semantics ??= data.runtimeType.toString()}**数据: $data');
      if (!_subject.isClosed) _subject.add(data);
    }
  }

  void addIfAbsent(T data) {
    // 如果最新值是_seedValue或者是空, 那么才add新数据, 换句话说, 就是如果event已经被add过
    // 了的话那就不add了, 用于第一次add
    if (_seedValue == latest || isEmpty(latest)) {
      add(data);
    }
  }

  Future<T> addStream(Stream<T> source, {bool cancelOnError: true}) {
    return _subject.addStream(source, cancelOnError: cancelOnError);
  }
}

/// 输出单元特有的成员
mixin OutputMixin<T, ARG_TYPE> on BaseIO<T> {
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
  _Fetch<T, ARG_TYPE> _fetch;

  /// 使用内部的trigger获取数据
  Future<T> update([ARG_TYPE arg]) {
    return _fetch(arg)
      ..then((data) {
        if (!_subject.isClosed) _subject.add(data);
      })
      ..catchError((error) {
        if (!_subject.isClosed) _subject.addError(error);
      });
  }
}

/// 内部数据是[List]特有的成员
mixin ListMixin<T> on BaseIO<List<T>> {
  /// 按条件过滤, 并发射过滤后的数据
  void filterItem(bool test(T element)) {
    if (!_subject.isClosed) _subject.add(latest.where(test).toList());
  }

  /// 追加, 并发射
  void append(T element, {bool fromHead = false}) {
    if (!_subject.isClosed) {
      if (fromHead) {
        _subject.add(latest..insert(0, element));
      } else {
        _subject.add(latest..add(element));
      }
    }
  }

  /// 替换指定index的元素, 并发射
  void replace(int index, T element) {
    if (!_subject.isClosed) {
      _subject.add(latest..replaceRange(index, index + 1, [element]));
    }
  }

  /// 替换最后一个的元素, 并发射
  void replaceLast(T element) {
    if (!_subject.isClosed) {
      _subject.add(latest
        ..replaceRange(
          latest.length - 1,
          latest.length,
          [element],
        ));
    }
  }

  /// 替换第一个的元素, 并发射
  void replaceFirst(T element) {
    if (!_subject.isClosed) {
      _subject.add(latest..replaceRange(0, 1, [element]));
    }
  }

  /// 删除最后一个的元素, 并发射
  void removeLast() {
    if (!_subject.isClosed) {
      _subject.add(latest..removeLast());
    }
  }

  /// 删除一个的元素, 并发射
  void remove(T element) {
    if (!_subject.isClosed) {
      _subject.add(latest..remove(element));
    }
  }

  /// 删除第一个的元素, 并发射
  void removeFirst() {
    if (!_subject.isClosed) {
      _subject.add(latest..removeAt(0));
    }
  }

  /// 删除指定索引的元素, 并发射
  void removeAt(int index) {
    if (!_subject.isClosed) {
      _subject.add(latest..removeAt(index));
    }
  }
}
