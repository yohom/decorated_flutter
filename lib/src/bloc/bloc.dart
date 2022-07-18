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

  /// 初始化
  @mustCallSuper
  void init() {}

  @mustCallSuper
  void dispose() {
    L.i('=============================================\n'
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
  void init() {
    super.init();
    for (final item in disposeBag) {
      item.init();
    }
  }

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

  /// 目前在BLoC内使用非IO的情况越来越多, 这里开放成dynamic类型
  ///
  /// 如果有未支持的类型, 就警告之.
  @protected
  List<dynamic> get disposeBag => [];

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
    for (final component in disposeBag) {
      if (component is BaseIO) {
        component.dispose();
      } else if (component is TextEditingController) {
        component.dispose();
      } else if (component is ValueNotifier) {
        component.dispose();
      } else if (component is PageController) {
        component.dispose();
      } else {
        L.w('未支持自动dispose的类型 ${component.runtimeType}, 请检查代码是否有bug!');
      }
    }
    if (!compositeSubscription.isDisposed) compositeSubscription.dispose();
    super.dispose();
  }
}

/// 全局BLoC, 全局BLoC和局部BLoC目前没用什么功能上的区别, 只是做一下区分
abstract class GlobalBLoC extends BLoC {
  GlobalBLoC(String semantics) : super(semantics);

  @protected
  List<dynamic> get disposeBag => [];

  @protected
  final CompositeSubscription compositeSubscription = CompositeSubscription();

  @override
  void reset() {
    for (var io in disposeBag) {
      if (io is BaseIO) io.reset();
    }
  }

  @override
  void dispose() {
    for (final component in disposeBag) {
      if (component is BaseIO) {
        component.dispose();
      } else if (component is TextEditingController) {
        component.dispose();
      } else if (component is ValueNotifier) {
        component.dispose();
      } else if (component is PageController) {
        component.dispose();
      } else {
        L.w('未支持自动dispose的类型 ${component.runtimeType}, 请检查代码是否有bug!');
      }
    }
    if (!compositeSubscription.isDisposed) compositeSubscription.dispose();
    super.dispose();
  }
}
