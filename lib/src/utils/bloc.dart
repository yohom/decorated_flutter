import 'package:framework/framework.dart';
import 'package:meta/meta.dart';

abstract class BLoC {
  String semantics;

  BLoC([this.semantics]);

  void reassemble() {}

  @mustCallSuper
  void close() {
    L.p('=============================================\n'
        '${semantics ??= runtimeType.toString()} closed '
        '\n=============================================');
  }
}
