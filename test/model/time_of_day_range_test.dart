import 'package:decorated_flutter/src/model/time_of_day_range.dart';
import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';

void main() {
  const start = TimeOfDay(hour: 9, minute: 30);
  const end = TimeOfDay(hour: 17, minute: 45);
  final range = TimeOfDayRange(start: start, end: end);

  test('计算时间范围的时长', () {
    expect(range.duration, const Duration(hours: 8, minutes: 15));
  });

  test('格式化时间范围', () {
    expect(range.format(), '09:30~17:45');
    expect(range.format(format: 'H:mm', divider: ' - '), '9:30 - 17:45');
  });

  test('判断时间是否在范围内', () {
    expect(range.contains(start), isTrue);
    expect(range.contains(end), isFalse);
    expect(range.contains(end, includeEnd: true), isTrue);
    expect(range.contains(const TimeOfDay(hour: 12, minute: 0)), isTrue);
    expect(range.contains(const TimeOfDay(hour: 8, minute: 59)), isFalse);
  });

  test('支持相等性和字符串表示', () {
    expect(
      range,
      TimeOfDayRange(
        start: TimeOfDay(hour: 9, minute: 30),
        end: TimeOfDay(hour: 17, minute: 45),
      ),
    );
    expect(range.toString(), 'TimeOfDay(09:30) - TimeOfDay(17:45)');
  });

  test('开始时间不能晚于结束时间', () {
    expect(
      () => TimeOfDayRange(
        start: const TimeOfDay(hour: 18, minute: 0),
        end: const TimeOfDay(hour: 9, minute: 0),
      ),
      throwsAssertionError,
    );
  });
}
