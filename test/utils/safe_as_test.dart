import 'package:decorated_flutter/src/utils/functions.dart' show safeAs;
import 'package:flutter_test/flutter_test.dart';

void main() {
  group('safeAs', () {
    test('支持可空标量类型', () {
      expect(safeAs<String?>(123), '123');
      expect(safeAs<int?>('12'), 12);
      expect(safeAs<double?>('1.25'), 1.25);
      expect(safeAs<bool?>(' TRUE '), true);
    });

    test('支持可空集合类型', () {
      expect(safeAs<List<dynamic>?>([1, 2]), [1, 2]);
      expect(safeAs<Map<String, dynamic>?>({1: 'value'}), {'1': 'value'});
    });

    test('转换失败或源值为 null 时返回 null', () {
      expect(safeAs<int?>('not an int'), isNull);
      expect(safeAs<String?>(null), isNull);
    });
  });
}
