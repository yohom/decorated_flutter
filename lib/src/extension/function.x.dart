import 'package:decorated_flutter/src/utils/functions.dart';

extension FunctionX on Function {
  void inNextFrame() {
    nextFrame(() => this());
  }
}
