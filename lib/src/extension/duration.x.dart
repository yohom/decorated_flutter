import 'package:decorated_flutter/decorated_flutter.dart';

extension DurationX on Duration {
  static Duration parse(String raw) {
    assert(raw.contains(':'), '字符串时间必须含有冒号(:)!');
    final parts = raw.split(':').map((e) => e.intValue ?? 0).toList();
    return Duration(
      hours: parts.getOrNull(0) ?? 0,
      minutes: parts.getOrNull(1) ?? 0,
      seconds: parts.getOrNull(2) ?? 0,
    );
  }

  String format([String format = 'HH:mm']) {
    String raw;
    if (format.contains('d')) {
      raw = format
          .replaceAll('d', inDays.toString())
          .replaceAll('HH', hourPart.toString().padLeft(2, '0'))
          .replaceAll('mm', minutePart.toString().padLeft(2, '0'))
          .replaceAll('ss', secondPart.toString().padLeft(2, '0'))
          .replaceAll('ms', (millisecondPart ~/ 10).toString().padLeft(2, '0'))
          .replaceAll('H', hourPart.toString())
          .replaceAll('m', minutePart.toString())
          .replaceAll('s', secondPart.toString());
    } else if (format.contains('HH')) {
      raw = format
          .replaceAll('HH', inHours.toString().padLeft(2, '0'))
          .replaceAll('mm', minutePart.toString().padLeft(2, '0'))
          .replaceAll('ss', secondPart.toString().padLeft(2, '0'))
          .replaceAll('ms', (millisecondPart ~/ 10).toString().padLeft(2, '0'))
          .replaceAll('H', hourPart.toString())
          .replaceAll('m', minutePart.toString())
          .replaceAll('s', secondPart.toString());
    } else if (format.contains('mm')) {
      raw = format
          .replaceAll('mm', inMinutes.toString().padLeft(2, '0'))
          .replaceAll('ss', secondPart.toString().padLeft(2, '0'))
          .replaceAll('ms', (millisecondPart ~/ 10).toString().padLeft(2, '0'))
          .replaceAll('H', hourPart.toString())
          .replaceAll('m', minutePart.toString())
          .replaceAll('s', secondPart.toString());
    } else {
      raw = format
          .replaceAll('ss', inSeconds.toString().padLeft(2, '0'))
          .replaceAll('ms', (millisecondPart ~/ 10).toString().padLeft(2, '0'))
          .replaceAll('H', hourPart.toString())
          .replaceAll('m', minutePart.toString())
          .replaceAll('s', secondPart.toString());
    }

    return raw;
  }

  int get hourPart => (inSeconds ~/ 3600) % 24;

  int get minutePart => inSeconds % 3600 ~/ 60;

  int get secondPart => inSeconds % 60;

  int get millisecondPart => inMilliseconds % 1000;

  @Deprecated('使用SDK中自带的方法替换')
  Duration operator ~/(int divider) {
    return Duration(milliseconds: inMilliseconds ~/ divider);
  }

  @Deprecated('使用SDK中自带的方法替换')
  Duration operator /(int divider) {
    return this ~/ divider;
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

extension OptionalDurationX on Duration? {
  Duration? operator ~/(int divider) {
    final shadow = this;
    if (shadow == null) return null;

    return Duration(milliseconds: shadow.inMilliseconds ~/ divider);
  }

  Duration? operator /(int divider) {
    return this ~/ divider;
  }

  Duration? operator *(num multiplier) {
    final shadow = this;
    if (shadow == null) return null;

    return Duration(milliseconds: (shadow.inMilliseconds * multiplier).toInt());
  }

  bool? operator <(Duration other) {
    final shadow = this;
    if (shadow == null) return null;

    return shadow < other;
  }

  bool? operator >(Duration other) {
    final shadow = this;
    if (shadow == null) return null;

    return shadow > other;
  }

  bool? operator <=(Duration other) {
    final shadow = this;
    if (shadow == null) return null;

    return shadow <= other;
  }

  bool? operator >=(Duration other) {
    final shadow = this;
    if (shadow == null) return null;

    return shadow >= other;
  }
}
