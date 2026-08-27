import 'package:decorated_flutter/src/extension/date_time.x.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:intl/date_symbol_data_local.dart';

void main() {
  setUpAll(initializeDateFormatting);

  test('copyWith', () {
    final now = DateTime.now();
    expect(
      now.copyWith(year: 2022),
      DateTime(
        2022,
        now.month,
        now.day,
        now.hour,
        now.minute,
        now.second,
        now.millisecond,
        now.microsecond,
      ),
    );
    expect(
      now.copyWith(year: 2022, month: 11),
      DateTime(
        2022,
        11,
        now.day,
        now.hour,
        now.minute,
        now.second,
        now.millisecond,
        now.microsecond,
      ),
    );
    expect(
      now.copyWith(year: 2022, month: 11, day: 1),
      DateTime(
        2022,
        11,
        1,
        now.hour,
        now.minute,
        now.second,
        now.millisecond,
        now.microsecond,
      ),
    );
    expect(
      now.copyWith(
        year: 2022,
        month: 11,
        day: 1,
        hour: 1,
        minute: 1,
        second: 1,
        millisecond: 1,
        microsecond: 1,
      ),
      DateTime(
        2022,
        11,
        1,
        1,
        1,
        1,
        1,
        1,
      ),
    );
  });

  test('一小时内显示分钟', () {
    expect(
      DateTime.now().subtract(const Duration(minutes: 10)).timeAgo,
      '10分钟前',
    );
  });

  test('一分钟内显示刚刚', () {
    expect(DateTime.now().subtract(const Duration(seconds: 30)).timeAgo, '刚刚');
    expect(DateTime.now().add(const Duration(seconds: 30)).timeAgo, '刚刚');
  });

  test('一天内显示小时', () {
    expect(
      DateTime.now().subtract(const Duration(hours: 3)).timeAgo,
      '3小时前',
    );
  });

  test('昨天显示昨天和时间', () {
    final now = DateTime.now();
    final yesterday = DateTime(
      now.year,
      now.month,
      now.day - 1,
      now.hour,
      now.minute,
    ).subtract(const Duration(minutes: 1));

    expect(yesterday.timeAgo, '昨天${yesterday.format('HH:mm')}');
  });

  test('更早时间按年份显示日期', () {
    final now = DateTime.now();
    final sameYear = DateTime(now.year, 1, 1);
    final anotherYear = DateTime(now.year - 1, now.month, now.day);

    if (sameYear.isBefore(now.subtract(const Duration(days: 1)))) {
      expect(sameYear.timeAgo, '01-01');
    }
    expect(anotherYear.timeAgo, anotherYear.format('yyyy-MM-dd'));
  });
}
