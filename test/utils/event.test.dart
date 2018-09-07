import 'package:flutter_test/flutter_test.dart';
import 'package:framework/framework.dart';
import 'package:mockito/mockito.dart';

void main() {
  group('构造器相关测试', () {
    group('test参数与isDistinct参数', () {
      test('test为null, isDistinct为true', () {
        final event = Event<int>(test: null, isDistinct: true);

        event.add(0);
        event.add(0);
        event.add(0);

//        verify(event.)
      });
    });
  });
}
