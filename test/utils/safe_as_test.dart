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

    test('支持日期对象、毫秒时间戳和日期字符串', () {
      final date = DateTime.fromMillisecondsSinceEpoch(1234);

      expect(safeAs<DateTime>(date), same(date));
      expect(safeAs<DateTime?>(1234), date);
      expect(safeAs<DateTime>('1234'), date);
      expect(
        safeAs<DateTime>('2026-11-26T00:00:00Z'),
        DateTime.utc(2026, 11, 26),
      );
      expect(safeAs<DateTime?>(8640000000000001), isNull);
      expect(safeAs<DateTime>('无效日期'), isNull);
      expect(safeAs<DateTime>(null), isNull);
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
