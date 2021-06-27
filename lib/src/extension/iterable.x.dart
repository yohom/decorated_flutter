import 'dart:math';

import 'package:decorated_flutter/src/utils/utils.export.dart';

extension IterableX<T> on Iterable<T> {
  T? find(bool Function(T) test) {
    try {
      return firstWhere(test);
    } catch (e) {
      return null;
    }
  }

  Map<S, List<T>> groupBy<S>(S Function(T) key) {
    var map = <S, List<T>>{};
    for (var element in this) {
      (map[key(element)] ??= []).add(element);
    }
    return map;
  }
}

extension ListX<T> on List<T> {
  T? get firstOrNull => getOrNull(0);

  T? get lastOrNull => getOrNull(length - 1);

  T? getOrNull(int index) {
    try {
      final result = this[index];
      return result;
    } catch (e) {
      return null;
    }
  }

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

  List<T> sublistOrEmpty(int start, [int? end]) {
    if (end != null) end = min(end, length);
    try {
      return sublist(start, end);
    } catch (e) {
      L.d(e);
      return [];
    }
  }

  List<T> padRight(int width, T padding) {
    if (length >= width) return this;

    addAll([for (int i = 0; i < width - length; i++) padding]);
    return this;
  }

  List<T> padLeft(int width, T padding) {
    if (length >= width) return this;

    insertAll(0, [for (int i = 0; i < width - length; i++) padding]);
    return this;
  }

  T get random {
    return this[Random().nextInt(length - 1)];
  }
}
