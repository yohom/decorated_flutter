import 'package:flutter/material.dart';

/// 一天内的时间范围。
///
/// 范围的精度为分钟，且[start]不能晚于[end]。与[DateTimeRange]类似，
/// 相同的[start]和[end]表示一个零时长范围。
@immutable
class TimeOfDayRange {
  TimeOfDayRange({required this.start, required this.end})
      : assert(
          start.hour * 60 + start.minute <= end.hour * 60 + end.minute,
        );

  /// 范围开始时间。
  final TimeOfDay start;

  /// 范围结束时间。
  final TimeOfDay end;

  /// 返回[start]和[end]之间的时长。
  Duration get duration =>
      Duration(minutes: _toMinutes(end) - _toMinutes(start));

  /// 判断[time]是否在范围内。
  bool contains(
    TimeOfDay time, {
    bool includeStart = true,
    bool includeEnd = false,
  }) {
    final value = _toMinutes(time);
    final startValue = _toMinutes(start);
    final endValue = _toMinutes(end);

    return (includeStart ? value >= startValue : value > startValue) &&
        (includeEnd ? value <= endValue : value < endValue);
  }

  @override
  bool operator ==(Object other) {
    if (other.runtimeType != runtimeType) return false;
    return other is TimeOfDayRange && other.start == start && other.end == end;
  }

  @override
  int get hashCode => Object.hash(start, end);

  @override
  String toString() => '$start - $end';

  static int _toMinutes(TimeOfDay value) => value.hour * 60 + value.minute;
}
