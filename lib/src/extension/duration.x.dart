extension DurationX on Duration {
  String format([String format = 'HH:mm']) {
    return format
        .replaceAll('HH', hours.toString().padLeft(2, '0'))
        .replaceAll('mm', minutes.toString().padLeft(2, '0'))
        .replaceAll('ss', seconds.toString().padLeft(2, '0'))
        .replaceAll('H', hours.toString())
        .replaceAll('m', minutes.toString())
        .replaceAll('s', seconds.toString());
  }

  int get hours => inSeconds ~/ 3600;

  int get minutes => inSeconds % 3600 ~/ 60;

  int get seconds => inSeconds % 60;

  Duration operator ~/(int divider) {
    return Duration(milliseconds: inMilliseconds ~/ divider);
  }
}
