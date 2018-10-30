import 'package:framework/framework.dart';
import 'package:meta/meta.dart';

abstract class BLoC {
  /// BLoC代表的语义
  String semantics;

  /// 所有的event集合, 主要是提供给RuntimeScaffold使用
  List<Event> eventList = <Event>[];

  BLoC([this.semantics]);

  /// 对应[State]的[reassemble]方法
  void reassemble() {}

  @mustCallSuper
  void close() {
    eventList.forEach((event) => event.close());
    L.p('=============================================\n'
        '${semantics ??= runtimeType.toString()} closed '
        '\n=============================================');
  }
}
