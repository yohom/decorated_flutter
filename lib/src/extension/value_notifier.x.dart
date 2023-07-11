import 'dart:async';
import 'dart:math';

import 'package:flutter/cupertino.dart';

extension ValueNotifierBoolX on ValueNotifier<bool> {
  void toggle() {
    value = !value;
  }
}

extension ValueNotifierIntX on ValueNotifier<int> {
  int plus({int? max}) {
    if (max != null) {
      value = min(max, value + 1);
    } else {
      value++;
    }
    return value;
  }

  int minus({int? min}) {
    if (min != null) {
      value = max(min, value - 1);
    } else {
      value--;
    }
    return value;
  }
}

extension ValueNotifierListX<T> on ValueNotifier<Iterable<T>> {
  void clear() {
    value = <T>[];
  }

  bool get isEmpty => value.isEmpty;

  bool get isNotEmpty => value.isNotEmpty;
}

extension ValueNotifierX<T> on ValueNotifier<T> {
  Stream<T> get toStream {
    StreamController<T>? controller;
    void __listener() {
      if (controller?.hasListener == true) {
        controller?.add(value);
      }
    }

    controller = StreamController<T>(
      onListen: () => addListener(__listener),
      onCancel: () {
        removeListener(__listener);
        if (controller?.hasListener != true) controller?.close();
      },
    );

    return controller.stream;
  }
}
