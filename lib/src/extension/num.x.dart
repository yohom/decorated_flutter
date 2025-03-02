import 'package:flutter/material.dart';
import 'package:intl/intl.dart';

import '../model/model.export.dart';

extension NumX on num {
  BorderRadius get radius {
    return BorderRadius.circular(toDouble());
  }

  bool isBetween(Range range, {bool inclusive = true}) {
    if (inclusive) {
      return this >= range.lower && this <= range.upper;
    } else {
      return this > range.lower && this < range.upper;
    }
  }

  bool gt(num other) {
    return this > other;
  }

  bool lt(num other) {
    return this < other;
  }
}

extension OptionalNumX<T extends num> on T? {
  T? operator +(T other) {
    final shadow = this;
    if (shadow != null) {
      return (shadow + other) as T;
    } else {
      return null;
    }
  }

  T? operator -(T other) {
    final shadow = this;
    if (shadow != null) {
      return (shadow - other) as T;
    } else {
      return null;
    }
  }

  T? operator *(T other) {
    final shadow = this;
    if (shadow != null) {
      return (shadow * other) as T;
    } else {
      return null;
    }
  }

  T? operator /(T other) {
    final shadow = this;
    if (shadow != null) {
      return (shadow / other) as T;
    } else {
      return null;
    }
  }

  T? operator ~/(T other) {
    final shadow = this;
    if (shadow != null) {
      return (shadow ~/ other) as T;
    } else {
      return null;
    }
  }

  T? operator %(T other) {
    final shadow = this;
    if (shadow != null) {
      return (shadow % other) as T;
    } else {
      return null;
    }
  }

  bool? operator >(T other) {
    final shadow = this;
    if (shadow != null) {
      return shadow > other;
    } else {
      return null;
    }
  }

  bool? operator >=(T other) {
    final shadow = this;
    if (shadow != null) {
      return shadow >= other;
    } else {
      return null;
    }
  }

  bool? operator <(T other) {
    final shadow = this;
    if (shadow != null) {
      return shadow < other;
    } else {
      return null;
    }
  }

  bool? operator <=(T other) {
    final shadow = this;
    if (shadow != null) {
      return shadow <= other;
    } else {
      return null;
    }
  }
}

extension DoubleX on double {
  double asFixed(int fractionDigits) {
    return double.parse(toStringAsFixed(fractionDigits));
  }

  double normalized(
    double selfRangeMin,
    double selfRangeMax, [
    double normalizedRangeMin = 0.0,
    double normalizedRangeMax = 1.0,
  ]) {
    return (normalizedRangeMax - normalizedRangeMin) *
            ((this - selfRangeMin) / (selfRangeMax - selfRangeMin)) +
        normalizedRangeMin;
  }

  double add(double other) {
    return this + other;
  }

  double subtract(double other) {
    return this - other;
  }
}

extension IntX on int {
  /// 时间转为格式化字符串
  String toFormattedString(String format) {
    final dateTime = DateTime.fromMillisecondsSinceEpoch(this);
    return DateFormat(format).format(dateTime);
  }

  /// 时间戳转时间
  DateTime toDateTime() {
    return DateTime.fromMillisecondsSinceEpoch(this);
  }

  Duration get milliseconds => Duration(milliseconds: this);

  Duration get seconds => Duration(seconds: this);

  Duration get minutes => Duration(minutes: this);

  Duration get hours => Duration(hours: this);

  Duration get days => Duration(days: this);

  /// 左补齐
  String padLeft(int width, [String padding = '0']) {
    return toString().padLeft(width, padding);
  }

  /// 右补齐
  String padRight(int width, [String padding = '0']) {
    return toString().padRight(width, padding);
  }

  /// 重复执行任务
  void repeat(Future<void> Function() callback) async {
    for (int i = 0; i < this; i++) {
      await callback();
    }
  }

  /// 转汉字
  String toCh() {
    switch (this) {
      case 0:
        return '零';
      case 1:
        return '一';
      case 2:
        return '二';
      case 3:
        return '三';
      case 4:
        return '四';
      case 5:
        return '五';
      case 6:
        return '六';
      case 7:
        return '七';
      case 8:
        return '八';
      case 9:
        return '九';
      case 10:
        return '十';
      default:
        return '其他';
    }
  }

  /// 转英文
  String toEn() {
    switch (this) {
      case 0:
        return 'Zero';
      case 1:
        return 'First';
      case 2:
        return 'Second';
      case 3:
        return 'Third';
      case 4:
        return 'Fourth';
      case 5:
        return 'Fifth';
      case 6:
        return 'Sixth';
      case 7:
        return 'Seventh';
      case 8:
        return 'Eighth';
      case 9:
        return 'Ninth';
      case 10:
        return 'Tenth';
      default:
        return '其他';
    }
  }

  int add(int other) {
    return this + other;
  }

  int subtract(int other) {
    return this - other;
  }
}
