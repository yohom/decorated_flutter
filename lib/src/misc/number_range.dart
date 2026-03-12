final class NumberRange {
  const NumberRange(this.min, this.max) : assert(min <= max);

  final num min;
  final num max;

  bool contains(num value, {bool includeMin = true, bool includeMax = true}) {
    final minCheck = includeMin ? value >= min : value > min;
    final maxCheck = includeMax ? value <= max : value < max;
    return minCheck && maxCheck;
  }
}
