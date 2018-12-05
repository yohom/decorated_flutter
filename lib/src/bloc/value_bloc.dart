import 'package:decorated_flutter/framework.dart';

class ValueBLoC<T> extends BLoC {
  final value = Event<T>();

  @override
  void close() {
    value.close();
    super.close();
  }
}
