import 'package:decorated_flutter/decorated_flutter.dart';
import 'package:flutter_test/flutter_test.dart';

void main() {
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
}
