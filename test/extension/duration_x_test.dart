import 'package:decorated_flutter/src/extension/duration.x.dart';
import 'package:flutter_test/flutter_test.dart';

void main() {
  test('Duration获取毫秒数', () {
    expect(const Duration(milliseconds: 2345).millisecondPart, 345);
  });

  test('Duration格式化', () {
    expect(const Duration(milliseconds: 2345).format('HH:mm:ss.ms'),
        '00:00:02.345');
  });
}
