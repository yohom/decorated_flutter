import 'dart:developer' as devtools show log;

import 'package:decorated_flutter/src/utils/empty_util.dart';

extension ObjectX on Object {
  void log([String? prefix]) => devtools.log('$prefix${toString()}');

  @Deprecated('没什么用')
  List<T> list<T>() {
    return (this as List).cast<T>();
  }

  @Deprecated('没什么用')
  Map<K, V> map<K, V>() {
    return (this as Map).cast<K, V>();
  }

  @Deprecated('没什么用')
  List<Map<K, V>> listMap<K, V>({bool growable = false}) {
    return (this as List)
        .cast<Map>()
        .map((e) => e.cast<K, V>())
        .toList(growable: growable);
  }
}

extension KtStandardExtension<T> on T {
  R let<R>(R Function(T self) block) {
    return block(this);
  }
  //
  // T apply(void Function() block) {
  //   block();
  //   return this;
  // }
  //
  // R also<R>(R Function(T self) func) {
  //   return func(this);
  // }
  //
  // R run<R>(R Function() func) {
  //   return func();
  // }

  T? takeIf(bool Function(T self) predicate) {
    if (predicate(this)) {
      return this;
    } else {
      return null;
    }
  }

  // shortcut: 不判断自定义类型的空状态，需要时扩展 isEmpty。
  T? takeIfNotEmpty() => isEmpty(this) ? null : this;
}
