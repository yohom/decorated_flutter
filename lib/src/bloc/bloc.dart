import 'package:framework/framework.dart';
import 'package:framework/src/bloc/bloc_io.dart';
import 'package:meta/meta.dart';

abstract class BLoC {
  /// BLoC代表的语义
  String semantics;

  BLoC([this.semantics]);

  /// 对应[State]的[reassemble]方法
  void reassemble() {}

  @mustCallSuper
  void close() {
    L.p('=============================================\n'
        '${semantics ??= runtimeType.toString()} closed '
        '\n=============================================');
  }
}

/// 顶层[BLoC], 这个[BLoC]只有子[BLoC], 没有[Event], 并且子[BLoC]都是[GlobalBLoC]
abstract class RootBLoC extends BLoC {
  RootBLoC([String semantics]) : super(semantics);

  List<GlobalBLoC> get globalBLoCList;

  @override
  void close() {
    globalBLoCList?.forEach((bloc) => bloc.close());

    super.close();
  }
}

/// 局部[BLoC], 局部[BLoC]通常包在Screen的外面, 作用范围就是这个Screen内部
abstract class LocalBLoC extends BLoC {
  LocalBLoC([String semantics]) : super(semantics);

  /// 所有的event集合, 主要是提供给RuntimeScaffold使用
  List<BaseIO> get ioList;

  @override
  void close() {
    ioList?.forEach((event) => event.dispose());

    super.close();
  }
}

/// 全局BLoC, 全局BLoC和局部BLoC目前没用什么功能上的区别, 只是做一下区分
abstract class GlobalBLoC extends BLoC {
  GlobalBLoC([String semantics]) : super(semantics);

  /// 所有的event集合, 主要是提供给RuntimeScaffold使用
  List<BaseIO> get ioList;

  @override
  void close() {
    ioList?.forEach((event) => event.dispose());

    super.close();
  }
}
