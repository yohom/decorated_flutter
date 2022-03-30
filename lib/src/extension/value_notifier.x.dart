import 'package:flutter/cupertino.dart';

extension ValueNotifierBoolX on ValueNotifier<bool> {
  void toggle() {
    value = !value;
  }
}
