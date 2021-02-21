import 'package:decorated_flutter/decorated_flutter.dart';

extension IterableX<T> on Iterable<T> {
  T find(bool test(T e)) {
    return firstWhere(test, orElse: returnNull);
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
  T get firstOrNull => getOrNull(0);

  T get lastOrNull => getOrNull(length - 1);

  T getOrNull(int index) {
    try {
      final result = this[index];
      return result;
    } catch (e) {
      return null;
    }
  }
}
