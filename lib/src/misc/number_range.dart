import 'dart:math' as math;

final class NumberRange<T extends num> {
  NumberRange(T a, T b)
      : min = math.min(a, b),
        max = math.max(a, b);
  NumberRange.single(T value) : this(value, value);

  final T min;
  final T max;

  bool contains(T value, {bool includeMin = true, bool includeMax = true}) {
    final minCheck = includeMin ? value >= min : value > min;
    final maxCheck = includeMax ? value <= max : value < max;
    return minCheck && maxCheck;
  }
}
