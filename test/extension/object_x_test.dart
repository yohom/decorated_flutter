import 'package:decorated_flutter/src/extension/object.x.dart';
import 'package:flutter_test/flutter_test.dart';

void main() {
  test('takeIfNotEmpty returns null for null and empty values', () {
    String? nullableValue;
    expect(nullableValue.takeIfNotEmpty(), isNull);
    expect(''.takeIfNotEmpty(), isNull);
    expect(<int>[].takeIfNotEmpty(), isNull);
    expect(<String, String>{}.takeIfNotEmpty(), isNull);
  });

  test('takeIfNotEmpty preserves non-empty values', () {
    final value = [1];
    expect(value.takeIfNotEmpty(), same(value));
  });
}
