import 'package:framework/framework.dart';
import 'package:meta/meta.dart';

abstract class BLoC {
  @mustCallSuper
  void close() {
    L.p('$runtimeType closed');
  }
}
