import 'package:flutter_test/flutter_test.dart';
import 'package:framework/src/utils/empty_util.dart' as util;

void main() {
  group('isEmpty', () {
    test('传入null ==> 返回true', () {
      expect(util.isEmpty(null), true);
    });
    test('传入空字符串 ==> 返回true', () {
      expect(util.isEmpty(''), true);
    });
    test('传入空数组 ==> 返回true', () {
      expect(util.isEmpty([]), true);
    });
    test('传入空Map ==> 返回true', () {
      expect(util.isEmpty({}), true);
    });

    test('传入空`[\'test\']` ==> 返回false', () {
      expect(util.isEmpty(['test']), false);
    });
    test('传入空`{\'key\': \'value\'}` ==> 返回false', () {
      expect(util.isEmpty({'key': 'value'}), false);
    });
  });
}
