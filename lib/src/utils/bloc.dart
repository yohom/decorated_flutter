import 'package:framework/framework.dart';
import 'package:meta/meta.dart';

abstract class BLoC {
  String semantics;

  BLoC([this.semantics]);

  @mustCallSuper
  void close() {
    L.p('${semantics ??= runtimeType.toString()} closed '
        '\n==================================');
  }
}
