extension DurationX on Duration {
  String format({String format = 'HH:mm'}) {
    final hours = inSeconds ~/ 3600;
    final minutes = inSeconds % 3600 ~/ 60;
    final seconds = inSeconds % 3600 ~/ 60 ~/ 60;
    return format
        .replaceAll('HH', hours.toString().padLeft(2, '0'))
        .replaceAll('mm', minutes.toString().padLeft(2, '0'))
        .replaceAll('ss', seconds.toString().padLeft(2, '0'))
        .replaceAll('H', hours.toString())
        .replaceAll('m', minutes.toString())
        .replaceAll('s', seconds.toString());
  }
}
