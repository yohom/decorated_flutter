class Range<T extends Comparable<T>> {
  final T lower;
  final T upper;

  const Range(this.lower, this.upper);

  bool contains(
    T number, {
    bool lowerInclusive = true,
    bool upperInclusive = false,
  }) {
    if (lowerInclusive && (number.compareTo(lower) < 0)) {
      return false;
    } else if (!lowerInclusive && (number.compareTo(lower) <= 0)) {
      return false;
    } else if (upperInclusive && (number.compareTo(upper) > 0)) {
      return false;
    } else if (!upperInclusive && (number.compareTo(upper) >= 0)) {
      return false;
    } else {
      return true;
    }
  }

  String format([String format = 'l-u']) {
    return format.replaceAll('l', '$lower').replaceAll('u', '$upper');
  }

  @override
  String toString() {
    return 'Range{lower: $lower, upper: $upper}';
  }
}
