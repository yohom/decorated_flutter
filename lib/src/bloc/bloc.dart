import 'package:framework/framework.dart';
import 'package:meta/meta.dart';

abstract class BLoC {
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
