import 'dart:async';

import 'package:rxdart/rxdart.dart';

import 'log.dart';

typedef void Listener<T>(T data);
typedef bool Equal<T>(T data1, T data2);

class Event<T> {
  Event({
    this.test,
    this.isDistinct = false,
    this.seedValue,
    this.acceptNull = false,
    this.sync = true,
    this.isBehavior = false,
  }) {
    _init();
  }

  void _init() {
    _subject = isBehavior
        ? BehaviorSubject<T>(seedValue: seedValue, sync: sync)
        : PublishSubject<T>(sync: sync);
    stream = _subject.stream;

    latest = seedValue;

    _subject.listen((data) => latest = data);
  }

  T latest;
  Observable<T> stream;

  AsObservableFuture<T> get first => stream.first;

  /// 判断新值与旧值是否相同
  Equal test;

  /// 是否只有不同的值(由[test]定义不同, 如果[test]为空, 那么直接用[==]判断)才发射新数据
  bool isDistinct;

  /// 初始值, 传递给内部的[_subject]
  T seedValue;

  /// 是否接受null
  bool acceptNull;

  /// 是否使用BehaviorSubject, 如果使用, 那么Event内部的[_subject]会保存最近一次的值
  /// 默认为false
  bool isBehavior;

  /// 是否同步发射数据, 传递给内部的[_subject]
  bool sync = true;

  Subject<T> _subject;

  void add(T data) {
    if (_subject.isClosed) {
      L.p('Observable.add:重新创建已关闭的Subject}');
      _init();
    }

    L.p('Event接收到${data.runtimeType}数据: $data');

    // 如果需要distinct的话, 就判断是否相同; 如果不需要distinct, 直接发射数据
    if (isDistinct) {
      // 如果是不一样的数据, 才发射新的通知,防止TabBar的addListener那种
      // 不停地发送通知(但是值又是一样)的情况
      if (test != null) {
        if (!test(latest, data)) {
          L.p('Event发送${data.runtimeType}数据: $data');
          _subject.add(data);
        }
      } else {
        if (data != latest) {
          L.p('Event发送${data.runtimeType}数据: $data');
          _subject.add(data);
        }
      }
    } else {
      L.p('Event发送${data.runtimeType}数据: $data');
      _subject.add(data);
    }
  }

  Observable<T> addStream(Stream<T> source, {bool cancelOnError: true}) {
    if (_subject.isClosed) {
      L.p('Observable.addStream:重新创建已关闭的Subject}');
      _init();
    }

    return Observable<T>(
      _subject..addStream(source, cancelOnError: cancelOnError),
    );
  }

  AsObservableFuture<T> addFuture(Future<T> source,
      {bool cancelOnError: true}) {
    if (_subject.isClosed) {
      L.p('Observable.addFuture:重新创建已关闭的Subject}');
      _init();
    }

    return Observable.fromFuture((_subject
              ..addStream(source.asStream(), cancelOnError: cancelOnError))
            .first)
        .first;
  }

  void listen(
    Listener<T> listener, {
    Function onError,
    void onDone(),
    bool cancelOnError,
  }) {
    if (_subject.isClosed) {
      L.p('Observable.listen:重新创建已关闭的Subject}');
      _init();
    }

    stream.listen(
      (data) {
        if (data == null && acceptNull) {
          listener(data);
        } else if (data != null) {
          listener(data);
        }
      },
      onError: onError,
      onDone: onDone,
      cancelOnError: cancelOnError,
    );
  }

  Observable<S> map<S>(S convert(T event)) {
    if (_subject.isClosed) {
      L.p('Observable.map:重新创建已关闭的Subject}');
      _init();
    }
    return _subject.map(convert);
  }

  Observable<T> where(bool test(T event)) {
    if (_subject.isClosed) {
      L.p('Observable.where:重新创建已关闭的Subject}');
      _init();
    }
    return _subject.where(test);
  }

  void clear() {
    if (_subject.isClosed) {
      L.p('Observable.clear:重新创建已关闭的Subject}');
      _init();
    }

    latest = seedValue;
    _subject.add(seedValue);
  }

  void close() {
    _subject.close();
  }
}
