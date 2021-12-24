import 'package:decorated_flutter/decorated_flutter.dart';
import 'package:flutter_test/flutter_test.dart';

void main() {
  group('OptionalInput', () {
    test('初始值为null', () {
      final input = OptionalInput<String>(semantics: '测试');
      expect(input.latest == null, true);

      input.add('aaa');
      expect(input.latest == 'aaa', true);
    });

    test('初始值为abc', () {
      final input = OptionalInput<String>(semantics: '测试', seedValue: 'abc');
      expect(input.latest == 'abc', true);

      input.add('aaa');
      expect(input.latest == 'aaa', true);

      input.add(null);
      expect(input.latest == null, true);
    });

    test('不接受空值', () {
      final input = OptionalInput<String>(semantics: '测试', acceptEmpty: false);
      expect(input.latest == null, true);

      input.add('');
      expect(input.latest == '', false);
      expect(input.latest == null, true);
    });

    test('值唯一', () {
      final input = OptionalInput<String>(semantics: '测试', isDistinct: true);
      expect(input.latest == null, true);

      input.add('abc');
      expect(input.latest == 'abc', true);
    });
  });
}
