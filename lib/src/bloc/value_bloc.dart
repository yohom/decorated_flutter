import 'package:decorated_flutter/decorated_flutter.dart';

class ValueBLoC<T> extends BLoC {
  final value = Static<T>();

  @override
  void reset() {}
}
