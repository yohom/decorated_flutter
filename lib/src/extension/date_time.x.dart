import 'package:decorated_flutter/src/utils/enums.dart';
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
    return DateFormat(format, 'zh').format(this);
  }

  bool isSameDay(DateTime other) {
    return year == other.year && month == other.month && day == other.day;
  }

  bool get isNextMonth {
    final now = DateTime.now();
    return now.month + 1 == month;
  }

  bool get isPrevMonth {
    final now = DateTime.now();
    return now.month - 1 == month;
  }

  bool get isNextYear {
    final now = DateTime.now();
    return now.year + 1 == year;
  }

  bool get isPrevYear {
    final now = DateTime.now();
    return now.year - 1 == year;
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

  bool get isLastYear {
    final now = DateTime.now();
    return now.year - 1 == year;
  }

  /// 是否最近[days]天内
  bool inLastDay(int days) {
    final now = DateTime.now();
    return now.difference(this).inDays <= days;
  }

  /// 前一个月
  DateTime prevMonth() {
    final month = this.month - 1;
    final year = this.year;
    return DateTime(month < 1 ? year - 1 : year, month < 1 ? 12 : month);
  }

  /// 下一个月
  DateTime nextMonth() {
    final month = this.month + 1;
    final year = this.year;
    return DateTime(month > 12 ? year + 1 : year, month > 12 ? 1 : month);
  }

  /// 星座
  Constellation get constellation {
    int month = this.month;
    int day = this.day;
    Constellation constellation = Constellation.unknown;

    switch (month) {
      case DateTime.january:
        constellation =
            day < 21 ? Constellation.capricorn : Constellation.aquarius;
        break;
      case DateTime.february:
        constellation =
            day < 20 ? Constellation.aquarius : Constellation.pisces;
        break;
      case DateTime.march:
        constellation = day < 21 ? Constellation.pisces : Constellation.aries;
        break;
      case DateTime.april:
        constellation = day < 21 ? Constellation.aries : Constellation.taurus;
        break;
      case DateTime.may:
        constellation = day < 22 ? Constellation.taurus : Constellation.gemini;
        break;
      case DateTime.june:
        constellation = day < 22 ? Constellation.gemini : Constellation.cancer;
        break;
      case DateTime.july:
        constellation = day < 23 ? Constellation.cancer : Constellation.leo;
        break;
      case DateTime.august:
        constellation = day < 24 ? Constellation.leo : Constellation.virgo;
        break;
      case DateTime.september:
        constellation = day < 24 ? Constellation.virgo : Constellation.libra;
        break;
      case DateTime.october:
        constellation = day < 24 ? Constellation.libra : Constellation.scorpio;
        break;
      case DateTime.november:
        constellation =
            day < 23 ? Constellation.scorpio : Constellation.sagittarius;
        break;
      case DateTime.december:
        constellation =
            day < 22 ? Constellation.sagittarius : Constellation.capricorn;
        break;
    }

    return constellation;
  }

  DateTime asDay() {
    return DateTime(year, month, day);
  }

  DateTime asMonth() {
    return DateTime(year, month);
  }

  DateTime asYear() {
    return DateTime(year);
  }

  int dayOfYear() {
    return difference(asYear()).inDays;
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
