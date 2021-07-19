import 'package:decorated_flutter/decorated_flutter.dart';
import 'package:flutter_test/flutter_test.dart';

void main() {
  group('OptionalStatic', () {
    test('set设置的值等于get拿到的值', () {
      final static = OptionalStatic<String>();
      expect(static.get() == null, true);

      static.set('abc');
      expect(static.get() == 'abc', true);
      static.set(null);
      expect(static.get() == null, true);
    });
  });

  group('OptionalInput', () {
    test('add值等于latest的值', () {
      final input = OptionalInput<String>(semantics: '测试');
      expect(input.latest == null, true);

      input.add('abc');
      expect(input.latest == 'abc', true);
    });

    test('acceptEmpty为FALSE时, 不接受被判定为空的值', () {
      // TODO
    });

    test('isDistinct为true时, 不接受被判定为相等的值', () {
      // TODO
    });

    test('设置了onReset时, 调用reset方法, latest应该是onReset的返回值', () {
      // TODO
    });

    test('设置了persistentKey时, 应该调用内部持久层的write方法', () {
      // TODO
    });
  });
}
