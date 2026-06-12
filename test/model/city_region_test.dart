import 'dart:io';

import 'package:decorated_flutter/decorated_flutter.dart';
import 'package:flutter_test/flutter_test.dart';

void main() {
  test('parse city picker data', () {
    final source = File(
      'assets/city_picker/china_regions.json',
    ).readAsStringSync();
    final data = CityRegion.listFromJsonString(source);

    expect(data.isNotEmpty, true);
    expect(data.first.code, '11');
    expect(data.first.name, '北京市');
    expect(data.first.children.first.children.isNotEmpty, true);
  });
}
