import 'package:intl/intl.dart';

extension DateTimeX on DateTime {
  String yMd() {
    return DateFormat.yMd().format(this);
  }

  String Md() {
    return DateFormat.Md().format(this);
  }

  String format([String format = 'yyyy-MM-dd HH:mm:ss']) {
    return DateFormat(format).format(this);
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
}
