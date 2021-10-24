import 'dart:async';

import 'package:decorated_flutter/src/utils/log.dart';
import 'package:flutter/widgets.dart';
import 'package:rxdart/rxdart.dart';

import 'bloc_io/base.dart';

@immutable
abstract class BLoC {
  /// BLoC代表的语义
  final String semantics;

  const BLoC(this.semantics);

  /// 重试
  Future<void> onErrorRetry() async {}

  /// 重置BLoC, 发射初始值
  void reset();

  @mustCallSuper
  void dispose() {
    L.d('=============================================\n'
        '$semantics closed '
        '\n=============================================');
  }
}

/// 顶层[BLoC], 这个[BLoC]只有子[BLoC], 没有[Event], 并且子[BLoC]都是[GlobalBLoC]
abstract class RootBLoC extends BLoC {
  const RootBLoC(String semantics) : super(semantics);

  @protected
  List<GlobalBLoC> get disposeBag => [];

  @override
  void reset() {
    for (var bloc in disposeBag) {
      bloc.reset();
    }
  }

  @override
  void dispose() {
    for (var bloc in disposeBag) {
      bloc.dispose();
    }
    super.dispose();
  }
}

/// 局部[BLoC], 局部[BLoC]通常包在Screen的外面, 作用范围就是这个Screen内部
abstract class LocalBLoC extends BLoC {
  LocalBLoC(String semantics) : super(semantics);

  @protected
  List<BaseIO> get disposeBag => [];

  @protected
  final CompositeSubscription compositeSubscription = CompositeSubscription();

  @override
  void reset() {
    for (var io in disposeBag) {
      io.reset();
    }
  }

  @override
  void dispose() {
    for (var event in disposeBag) {
      event.dispose();
    }
    if (!compositeSubscription.isDisposed) compositeSubscription.dispose();
    super.dispose();
  }
}

/// 全局BLoC, 全局BLoC和局部BLoC目前没用什么功能上的区别, 只是做一下区分
abstract class GlobalBLoC extends BLoC {
  GlobalBLoC(String semantics) : super(semantics);

  @protected
  List<BaseIO> get disposeBag => [];

  @protected
  final CompositeSubscription compositeSubscription = CompositeSubscription();

  @override
  void reset() {
    for (var io in disposeBag) {
      io.reset();
    }
  }

  @override
  void dispose() {
    for (var event in disposeBag) {
      event.dispose();
    }
    if (!compositeSubscription.isDisposed) compositeSubscription.dispose();
    super.dispose();
  }
}
