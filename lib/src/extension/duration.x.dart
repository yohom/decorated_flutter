extension DurationX on Duration {
  String format([String format = 'HH:mm']) {
    return format
        .replaceAll('d', inDays.toString())
        .replaceAll('HH', hourPart.toString().padLeft(2, '0'))
        .replaceAll('mm', minutePart.toString().padLeft(2, '0'))
        .replaceAll('ss', secondPart.toString().padLeft(2, '0'))
        .replaceAll('ms', (millisecondPart ~/ 10).toString().padLeft(2, '0'))
        .replaceAll('H', hourPart.toString())
        .replaceAll('m', minutePart.toString())
        .replaceAll('s', secondPart.toString());
  }

  int get hourPart => inSeconds ~/ 3600;

  int get minutePart => inSeconds % 3600 ~/ 60;

  int get secondPart => inSeconds % 60;

  int get millisecondPart => inMilliseconds % 1000;

  Duration operator ~/(int divider) {
    return Duration(milliseconds: inMilliseconds ~/ divider);
  }

  Duration operator /(int divider) {
    return this ~/ divider;
  }

  Duration operator *(num multiplier) {
    return Duration(milliseconds: (inMilliseconds * multiplier).toInt());
  }

  double percentOf(Duration other) {
    return inMilliseconds / other.inMilliseconds;
  }

  Duration clamp(Duration lower, Duration upper) {
    final result =
        inMilliseconds.clamp(lower.inMilliseconds, upper.inMilliseconds);
    return Duration(milliseconds: result);
  }
}
