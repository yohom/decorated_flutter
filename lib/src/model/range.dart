class Range<T extends num> {
  final T lower;
  final T upper;

  const Range(this.lower, this.upper);

  String format([String format = 'l-u']) {
    return format.replaceAll('l', '$lower').replaceAll('u', '$upper');
  }

  @override
  String toString() {
    return 'Range{lower: $lower, upper: $upper}';
  }
}
