import 'package:decorated_flutter/decorated_flutter.dart';
import 'package:flutter_test/flutter_test.dart';

void main() {
  test('prevMonth', () {
    final date = DateTime(2022, 1);
    expect(prevMonth(date), DateTime(2021, 12));
  });

  test('currentMonth', () {
    final date = DateTime(2022, 1);
    expect(currentMonth(date), DateTime(2022, 1));
  });

  test('nextMonth', () {
    final date = DateTime(2022, 12);
    expect(nextMonth(date), DateTime(2023, 1));
  });

  test('等待某个操作符合条件', () {
    final date = DateTime(2022, 12);
    expect(nextMonth(date), DateTime(2023, 1));
  });
}
