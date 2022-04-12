import 'dart:async';
import 'dart:math' as math;

import 'package:decorated_flutter/decorated_flutter.dart';
import 'package:flutter/foundation.dart';

part 'optional/optional.dart';
part 'optional/optional_int.dart';
part 'optional/optional_list.dart';
part 'optional/optional_page.dart';
part 'required/required.dart';
part 'required/required_bool.dart';
part 'required/required_int.dart';
part 'required/required_list.dart';
part 'required/required_page.dart';

typedef _FetchCallback<R, T> = Future<R> Function(T arg);
typedef _PageFetchCallback<R, T> = Future<R> Function(int page, T arg);
typedef _MergeListCallback<T> = List<T> Function(
    List<T> current, List<T> newList);
typedef _NoMoreDataCallback<T> = bool Function(List<T> newList);
typedef _SerializeCallback<T> = dynamic Function(T);
typedef _DeserializeCallback<T> = T Function(dynamic);

abstract class BaseIO<T> {
  @Deprecated('使用自带的持久层')
  static Persistence? _persistence;

  @Deprecated('使用自带的持久层')
  static void registerPersistence(Persistence persistence) {
    _persistence = persistence;
  }

  BaseIO({
    /// 初始值, 传递给内部的[_subject]
    required T seedValue,

    /// Event代表的语义
    required String semantics,

    /// 是否同步发射数据, 传递给内部的[_subject]
    bool sync = true,

    /// 是否打印日志, 有些IO add比较频繁时, 影响日志观看
    bool printLog = true,

    /// 是否使用BehaviorSubject, 如果使用, 那么Event内部的[_subject]会保存最近一次的值
    bool isBehavior = true,

    /// 重置回调方法, 如果设置了, 则调用reset的时候会优先使用此回调的返回值
    T Function()? onReset,

    /// 是否持久化数据, 如果是持久化数据, 则数据变化时便会持久化, 且如果是BehaviorSubject
    /// 则下次构造时会发射上一次持久化的数据
    String? persistentKey,

    /// 反序列化
    _DeserializeCallback<T>? onDeserialize,

    /// 序列化
    _SerializeCallback<T>? onSerialize,
  })  : assert(
          (persistentKey != null &&
                  onSerialize != null &&
                  onDeserialize != null) ||
              persistentKey == null,
          '设置persistentKey时, 必须同时设置onSerialize和onDeserialize',
        ),
        _semantics = semantics,
        _seedValue = seedValue,
        _printLog = printLog,
        latest = seedValue,
        _onReset = onReset,
        _persistentKey = persistentKey,
        _onSerialize = onSerialize,
        _onDeserialize = onDeserialize,
        _subject = isBehavior
            ? seedValue != null
                ? BehaviorSubject<T>.seeded(seedValue, sync: sync)
                : BehaviorSubject<T>(sync: sync)
            : PublishSubject<T>(sync: sync) {
    _subject.listen((data) {
      latest = data;
      if (_persistentKey != null) {
        // 维持旧版兼容
        if (_persistence != null) {
          _persistence!.writeValue(_persistentKey!, data);
        } else {
          L.w('未注册持久层! 请调用BaseIO.registerPersistence注册持久层');
        }

        // 新版内建持久层
        if (_onSerialize != null && data != null) {
          // 这里只持久化非空的值
          final serialized = _onSerialize!(data);
          assert(isJsonable(serialized), '序列化之后应是jsonable值!');

          gHiveBox.then((it) => it.put(_persistentKey!, serialized));
        }
      }
      if (_printLog) {
        L.d('当前$semantics latest: $latest');
      }
    });
    // 如果是BehaviorSubject, 则检查是否有持久化下来的数据, 有则发射
    if (isBehavior) {
      if (_persistentKey != null) {
        // 维持旧版兼容
        try {
          final value = _persistence?.readValue(_persistentKey!);
          if (value != null) _subject.add(value);
        } catch (e) {
          L.w('读取持久层数据发生异常 $e, 删除key: [$_persistentKey]');
          _persistence?.removeKey(_persistentKey!);
        }

        // 新版内建持久层
        if (_onDeserialize != null) {
          try {
            gHiveBox.then((box) {
              final value = _onDeserialize!(box.get(_persistentKey!));
              if (value != null) _subject.add(value);
            });
          } catch (e) {
            L.w('读取持久层数据发生异常 $e, 删除key: [$_persistentKey]');
            gHiveBox.then((box) => box.delete(_persistentKey!));
          }
        }
      }
    }
  }

  /// 最新的值
  T latest;

  /// 初始值
  @protected
  final T _seedValue;

  /// 初始值
  @protected
  final bool _printLog;

  /// 语义
  @protected
  final String _semantics;

  /// 内部中转对象
  @protected
  final Subject<T> _subject;

  /// 重置回调方法
  @protected
  final T Function()? _onReset;

  /// 持久化key
  final String? _persistentKey;

  /// 序列化回调
  final _SerializeCallback<T>? _onSerialize;

  /// 反序列化回调
  final _DeserializeCallback<T>? _onDeserialize;

  void addError(Object error, [StackTrace? stackTrace]) {
    if (_subject.isClosed) return;

    _subject.addError(error, stackTrace);
  }

  Stream<S> map<S>(S Function(T event) convert) {
    return _subject.map(convert);
  }

  Stream<T> where(bool Function(T event) test) {
    return _subject.where(test);
  }

  Stream<R> whereType<R>() {
    return _subject.whereType<R>();
  }

  Stream<T> distinct([bool Function(T previous, T next)? test]) {
    return test != null ? _subject.distinct(test) : _subject.distinct();
  }

  Stream<T> sample(Duration duration) {
    return _subject.sampleTime(duration);
  }

  /// 清理保存的值, 恢复成初始状态
  ///
  /// 如果设置了[_onReset], 则以[_onReset]的返回值为准
  void reset() {
    if (_subject.isClosed) return;

    final _resetValue = _onReset != null ? _onReset!() : _seedValue;

    if (_printLog) {
      L.d('[$_semantics]事件 重置为 $_resetValue');
    }

    _subject.add(_resetValue);

    if (_persistentKey != null) {
      // 兼容旧版逻辑
      _persistence?.writeValue(_persistentKey!, _resetValue);
      // 新版内建持久层
      if (_onSerialize != null && _resetValue != null) {
        final serialized = _onSerialize!(_resetValue);
        assert(isJsonable(serialized), '序列化之后应是jsonable值!');

        gHiveBox.then((box) => box.put(_persistentKey!, serialized));
      }
    }
  }

  /// 重新发送数据 用户修改数据后刷新的场景
  void invalidate() {
    if (_subject.isClosed) return;

    _subject.add(latest);
  }

  /// 关闭流
  void dispose() {
    if (_subject.isClosed) return;

    if (_printLog) {
      L.d('$_semantics事件 disposed ');
    }
    _subject.close();
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

/// 没有数据, 只发射信号的IO
class Signal extends IO<dynamic> {
  Signal({required String semantics, bool isBehavior = false})
      : super(
          seedValue: null,
          semantics: semantics,
          isBehavior: isBehavior,
          fetch: (_) => throw '不能在 [$semantics] Signal中调用update方法',
        );

  /// 是否有粘性信号可以处理
  bool get hasStickySignal {
    return latest != null;
  }

  @override
  void reset() {
    // do nothing
  }

  // 隐藏add方法
  @protected
  @override
  void add(dynamic data) {
    super.add(data);
  }

  /// 发射信号
  void emit() {
    add(Object());
  }
}

/// 对某个io进行变换
class Mapper<T, R> extends BaseIO<R> {
  Mapper({
    required BaseIO<T> upstream,
    required String semantics,
    required R Function(T) mapper,
    R? seedValue,
  })  : _upstream = upstream,
        _mapper = mapper,
        super(
          seedValue: seedValue ?? mapper(upstream._seedValue),
          semantics: semantics,
        ) {
    _subscription = upstream._subject.map(mapper).listen(_subject.add);
  }

  final BaseIO<T> _upstream;

  final R Function(T) _mapper;

  late final StreamSubscription _subscription;

  Stream<R> get stream {
    return _subject.stream;
  }

  void pull() {
    _subject.add(_mapper(_upstream.latest));
  }

  @override
  void dispose() {
    _subscription.cancel();
    super.dispose();
  }
}
