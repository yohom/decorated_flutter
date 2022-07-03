import 'dart:math';

import 'package:flutter/cupertino.dart';

extension ValueNotifierBoolX on ValueNotifier<bool> {
  void toggle() {
    value = !value;
  }
}

extension ValueNotifierIntX on ValueNotifier<int> {
  void plus({int? max}) {
    if (max != null) {
      value = min(max, value + 1);
    } else {
      value++;
    }
  }

  void minus({int? min}) {
    if (min != null) {
      value = max(min, value - 1);
    } else {
      value--;
    }
  }
}
