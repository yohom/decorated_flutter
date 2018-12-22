import 'package:decorated_flutter/decorated_flutter.dart';
import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';

void main() {
  test('color测试, 对应的颜色应该符合预期', () {
    expect(colorError, Colors.red);
    expect(textColorMinor, Colors.grey);
    expect(kBackgroundColor, Color(0xFFF1F5FA));
  });
}
