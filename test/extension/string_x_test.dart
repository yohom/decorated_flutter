import 'package:decorated_flutter/src/extension/string.x.dart';
import 'package:flutter_test/flutter_test.dart';

void main() {
  test('string截取', () {
    expect(
      '#/definitions/WebResponse«MdUserDTO»'.substringBetween('«', and: '»'),
      'MdUserDTO',
    );
  });
  test('string比大小', () {
    expect(r'$MT301' > r'$MT302', false);
    expect(r'$MTS09' < r'$MTS14', true);
  });
  test('截取字符串', () {
    expect(
      '/test/to/path.zip'.substringAfterLast('.'),
      'zip',
    );
    expect(
      '/test/to/path.zip'.substringAfterLast('.', includeSeparator: true),
      '.zip',
    );
  });
}
