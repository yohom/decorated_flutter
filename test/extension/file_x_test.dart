import 'dart:io';

import 'package:decorated_flutter/decorated_flutter.dart';
import 'package:flutter_test/flutter_test.dart';

void main() {
  final testFile = File(
      '/storage/emulated/0/Pictures/WeiXin/mmexport1659138725395.mp4?cover=/data/user/0/com.yilidouzi.memoir/app_flutter/thumbna');
  test('name', () {
    expect(testFile.name, 'mmexport1659138725395.mp4');
  });
  test('nameWithoutExtension', () {
    expect(testFile.nameWithoutExtension, 'mmexport1659138725395');
  });
}
