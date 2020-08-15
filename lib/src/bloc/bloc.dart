import 'package:decorated_flutter/decorated_flutter.dart';
import 'package:decorated_flutter/src/bloc/bloc_io.dart';
import 'package:flutter/widgets.dart';

@immutable
abstract class BLoC {
  /// BLoC代表的语义
  final String semantics;

  BLoC([this.semantics]);

  /// 重试
  void onErrorRetry() {}

  @mustCallSuper
  void dispose() {
    L.d('=============================================\n'
        '${semantics ?? runtimeType.toString()} closed '
        '\n=============================================');
  }
}

/// 顶层[BLoC], 这个[BLoC]只有子[BLoC], 没有[Event], 并且子[BLoC]都是[GlobalBLoC]
abstract class RootBLoC extends BLoC {
  RootBLoC([String semantics]) : super(semantics);

  @protected
  List<GlobalBLoC> get disposeBag => [];

  @override
  void dispose() {
    disposeBag?.forEach((bloc) => bloc.dispose());

    super.dispose();
  }
}

/// 局部[BLoC], 局部[BLoC]通常包在Screen的外面, 作用范围就是这个Screen内部
abstract class LocalBLoC extends BLoC {
  LocalBLoC([String semantics]) : super(semantics);

  @protected
  List<BaseIO> get disposeBag => [];

  @override
  void dispose() {
    disposeBag?.forEach((event) => event.dispose());
    super.dispose();
  }
}

/// 全局BLoC, 全局BLoC和局部BLoC目前没用什么功能上的区别, 只是做一下区分
abstract class GlobalBLoC extends BLoC {
  GlobalBLoC([String semantics]) : super(semantics);

  @protected
  List<BaseIO> get disposeBag => [];

  @override
  void dispose() {
    disposeBag?.forEach((event) => event.dispose());
    super.dispose();
  }
}
