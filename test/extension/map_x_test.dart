import 'package:decorated_flutter/decorated_flutter.dart';
import 'package:flutter_test/flutter_test.dart';

void main() {
  test('keyPath获取值', () {
    expect(
      {
        'a': {
          'b': {'c': 'd'}
        }
      }.valueFor(keyPath: 'a.b.c'),
      'd',
    );
  });
}
