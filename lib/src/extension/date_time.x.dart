import 'package:intl/intl.dart';

extension DateTimeX on DateTime {
  String yMd() {
    return DateFormat.yMd().format(this);
  }

  // ignore: non_constant_identifier_names
  String Md() {
    return DateFormat.Md().format(this);
  }

  String format([String format = 'yyyy-MM-dd HH:mm:ss']) {
    return DateFormat(format).format(this);
  }

  bool isSameDay(DateTime other) {
    return year == other.year && month == other.month && day == other.day;
  }

  bool get isToday {
    final now = DateTime.now();
    final today = DateTime(now.year, now.month, now.day);
    return DateTime(year, month, day) == today;
  }

  bool get isYesterday {
    final now = DateTime.now();
    final today = DateTime(now.year, now.month, now.day - 1);
    return DateTime(year, month, day) == today;
  }

  bool get isTomorrow {
    final now = DateTime.now();
    final today = DateTime(now.year, now.month, now.day + 1);
    return DateTime(year, month, day) == today;
  }

  DateTime copyWith({
    int? year,
    int? month,
    int? day,
    int? hour,
    int? minute,
    int? second,
    int? millisecond,
    int? microsecond,
  }) {
    return DateTime(
      year ?? this.year,
      month ?? this.month,
      day ?? this.day,
      hour ?? this.hour,
      minute ?? this.minute,
      second ?? this.second,
      millisecond ?? this.millisecond,
      microsecond ?? this.microsecond,
    );
  }
}
