import 'package:decorated_flutter/decorated_flutter.dart';
import 'package:flutter_test/flutter_test.dart';

void main() {
  group('OptionalInput', () {
    test('add值等于latest的值', () {
      final input = OptionalInput<String>(semantics: '测试');
      expect(input.latest == null, true);

      input.add('abc');
      expect(input.latest == 'abc', true);
    });

    test('acceptEmpty为FALSE时, 不接受被判定为空的值', () {
      final input = OptionalInput<String>(semantics: '测试', acceptEmpty: false);

      input.add('');
      expect(input.latest == null, true);
    });

    test('isDistinct为true时, 不接受被判定为相等的值', () {});

    test('调用reset方法, latest应该是seedValue', () {
      final input = OptionalInput<String>(semantics: '测试', seedValue: 'seed');

      input.reset();
      expect(input.latest == 'seed', true);
    });

    test('设置了onReset时, 调用reset方法, latest应该是onReset的返回值', () {
      final input = OptionalInput<String>(
        semantics: '测试',
        onReset: () => 'reset',
        seedValue: 'seed',
      );

      input.reset();
      expect(input.latest == 'reset', true);
    });

    test('设置了persistentKey时, 应该调用内部持久层的write方法', () {});
  });
}
