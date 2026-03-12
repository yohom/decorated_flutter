final class NumberRange<T extends num> {
  const NumberRange(this.min, this.max) : assert(min <= max);

  final T min;
  final T max;

  bool contains(T value, {bool includeMin = true, bool includeMax = true}) {
    final minCheck = includeMin ? value >= min : value > min;
    final maxCheck = includeMax ? value <= max : value < max;
    return minCheck && maxCheck;
  }
}
