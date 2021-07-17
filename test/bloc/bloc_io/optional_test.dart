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
}
