import 'package:decorated_flutter/src/extension/string.x.dart';
import 'package:flutter_test/flutter_test.dart';

void main() {
  test('string截取', () {
    expect(
      '#/definitions/WebResponse«MdUserDTO»'.substringBetween('«', and: '»'),
      'MdUserDTO',
    );
  });
}
