import 'package:decorated_flutter/decorated_flutter.dart';

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

  T find(bool test(T e)) {
    return firstWhere(test, orElse: returnNull);
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
}
