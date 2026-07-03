import 'package:decorated_flutter/src/utils/enums.dart';
import 'package:flutter/material.dart';
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

  bool isSameDay(DateTime? other) {
    if (other == null) return false;

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

  @Deprecated('请使用 zodiac 代替')
  Zodiac get constellation => zodiac;

  /// Zodiac
  Zodiac get zodiac {
    int month = this.month;
    int day = this.day;
    Zodiac zodiac = Zodiac.unknown;

    switch (month) {
      case DateTime.january:
        zodiac = day < 21 ? Zodiac.capricorn : Zodiac.aquarius;
        break;
      case DateTime.february:
        zodiac = day < 20 ? Zodiac.aquarius : Zodiac.pisces;
        break;
      case DateTime.march:
        zodiac = day < 21 ? Zodiac.pisces : Zodiac.aries;
        break;
      case DateTime.april:
        zodiac = day < 21 ? Zodiac.aries : Zodiac.taurus;
        break;
      case DateTime.may:
        zodiac = day < 22 ? Zodiac.taurus : Zodiac.gemini;
        break;
      case DateTime.june:
        zodiac = day < 22 ? Zodiac.gemini : Zodiac.cancer;
        break;
      case DateTime.july:
        zodiac = day < 23 ? Zodiac.cancer : Zodiac.leo;
        break;
      case DateTime.august:
        zodiac = day < 24 ? Zodiac.leo : Zodiac.virgo;
        break;
      case DateTime.september:
        zodiac = day < 24 ? Zodiac.virgo : Zodiac.libra;
        break;
      case DateTime.october:
        zodiac = day < 24 ? Zodiac.libra : Zodiac.scorpio;
        break;
      case DateTime.november:
        zodiac = day < 23 ? Zodiac.scorpio : Zodiac.sagittarius;
        break;
      case DateTime.december:
        zodiac = day < 22 ? Zodiac.sagittarius : Zodiac.capricorn;
        break;
    }

    return zodiac;
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

  /// 单天转换成日期范围
  DateTimeRange asDateRange() {
    return DateTimeRange(
      start: asDay(),
      end: asDay().add(const Duration(days: 1)),
    );
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
