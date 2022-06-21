import 'dart:math';

import 'package:decorated_flutter/src/mixin/mixin.export.dart';
import 'package:decorated_flutter/src/utils/utils.export.dart';

extension IterableX<T> on Iterable<T> {
  /// 寻找元素, 找不到就返回null, 如果多余一个就返回第一个
  T? find(bool Function(T it) test) {
    try {
      return firstWhere(test);
    } catch (e) {
      return null;
    }
  }

  /// 最后一个索引
  int get lastIndex {
    return length - 1;
  }

  T? operator [](int index) => length > index ? elementAt(index) : null;

  Iterable<T> operator +(T other) => followedBy([other]);

  Iterable<T> operator -(T other) => where((element) => element != other);

  Map<S, List<T>> groupBy<S>(S Function(T) key) {
    var map = <S, List<T>>{};
    for (var element in this) {
      (map[key(element)] ??= []).add(element);
    }
    return map;
  }

  /// 从第0个元素向后fallback, 直到符合[until]的条件
  ///
  /// 使用场景: 有时候数据源获取来的数据是空字符串(''), 要过滤这种情况非常繁琐, 这个时候就可以
  /// 使用此方法来简化操作
  T? fallback({bool Function(T?) until = isNotEmpty}) {
    for (final item in this) {
      if (until(item)) return item;
    }
    return null;
  }

  Iterable<R> mapIndex<R>(R Function(int index, T e) cb) {
    return [for (var i = 0; i < length; i++) cb(i, elementAt(i))];
  }

  /// 获取随机元素
  T get randomOne {
    return elementAt(Random().nextInt(length));
  }

  List<T> whereNotEmpty() => where(isNotEmpty).cast<T>().toList();
}

extension NullableIterableX<T> on Iterable<T?>? {
  List<T> whereNotNull() => (this ?? []).where(notNull).cast<T>().toList();
}

extension NumIterableX on Iterable<num> {
  num sum() {
    return reduce((value, element) => value + element);
  }
}

extension ListX<T> on List<T> {
  T? get firstOrNull => getOrNull(0);

  T? get lastOrNull => getOrNull(length - 1);

  void replace(int index, T element) {
    replaceRange(index, index + 1, [element]);
  }

  T? getOrNull(int index) {
    try {
      final result = this[index];
      return result;
    } catch (e) {
      return null;
    }
  }

  /// 重复列表[factor]次
  List<T> operator *(int factor) {
    return [for (int i = 0; i < factor; i++) ...this];
  }

  /// 按[count]数给列表分组
  List<List<T>> buffer(int count) {
    final result = <List<T>>[];

    final totalRound = (length / count).ceil();
    for (int i = 0; i < totalRound; i++) {
      final round = <T>[];
      for (int j = (i * count); j < ((i + 1) * count); j++) {
        if (j < length) {
          round.add(this[j]);
        } else {
          break;
        }
      }
      result.add(round);
    }

    return result;
  }

  /// 获取子列表, 如果获取失败就返回空列表
  List<T> sublistOrEmpty(int start, [int? end]) {
    if (end != null) end = min(end, length);
    try {
      return sublist(start, end);
    } catch (e) {
      L.d(e);
      return [];
    }
  }

  /// 右补齐
  List<T> padRight(int width, T padding) {
    if (length >= width) return this;

    addAll([for (int i = 0; i < width - length; i++) padding]);
    return this;
  }

  /// 左补齐
  List<T> padLeft(int width, T padding) {
    if (length >= width) return this;

    insertAll(0, [for (int i = 0; i < width - length; i++) padding]);
    return this;
  }
}

extension SelectableListX on List<Selectable> {
  Selectable? get selected => find((it) => it.selected);
}
