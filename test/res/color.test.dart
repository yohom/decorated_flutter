import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:framework/framework.dart';

void main() {
  test('color测试, 对应的颜色应该符合预期', () {
    expect(colorError, Colors.red);
    expect(textColorMinor, Colors.grey);
    expect(kBackgroundColor, Color(0xFFF1F5FA));
  });
}
