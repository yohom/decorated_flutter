class Range<T extends num> {
  final T lower;
  final T upper;

  const Range(this.lower, this.upper);

  bool contains(
    num number, {
    bool lowerInclusive = true,
    bool upperInclusive = false,
  }) {
    if (lowerInclusive && (number < lower)) {
      return false;
    } else if (!lowerInclusive && (number <= lower)) {
      return false;
    } else if (upperInclusive && (number > upper)) {
      return false;
    } else if (!upperInclusive && (number >= upper)) {
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
