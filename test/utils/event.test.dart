import 'package:decorated_flutter/decorated_flutter.dart';
import 'package:flutter_test/flutter_test.dart';

void main() {
  group('构造器相关测试:', () {
    group('同步Event:', () {
      test('其他默认配置, add数据后**同步**去取latest**应该**是add进去的数据', () {
        final target = Event<int>(sync: true);

        target.add(1);
        expect(target.latest, 1);

        target.add(2);
        expect(target.latest, 2);

        target.add(3);
        expect(target.latest, 3);
      });

      test('配置seedValue不为空, add数据后**同步**去取latest**应该**是add进去的数据', () {
        final target = Event<String>(sync: true, seedValue: 'test_value');

        target.add('1');
        expect(target.latest, '1');

        target.add('2');
        expect(target.latest, '2');

        target.add('3');
        expect(target.latest, '3');
      });

      test(
        '配置seedValue不为空 && isBehavior = true, '
            'add数据后**同步**去取latest**应该**是add进去的数据',
        () {
          final target = Event<String>(
            sync: true,
            seedValue: 'test_value',
            isBehavior: true,
          );

          target.add('1');
          expect(target.latest, '1');

          target.add('2');
          expect(target.latest, '2');

          target.add('3');
          expect(target.latest, '3');
        },
      );
    });

    group('异步Event:', () {
      test('其他默认配置, add数据后**同步**去取latest**不应该**是add进去的数据', () {
        final target = Event<int>(sync: false);

        target.add(1);
        expect(target.latest != 1, true);

        target.add(2);
        expect(target.latest != 2, true);

        target.add(3);
        expect(target.latest != 3, true);
      });
    });
  });
}
