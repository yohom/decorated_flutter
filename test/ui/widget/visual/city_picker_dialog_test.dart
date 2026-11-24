import 'package:decorated_flutter/src/model/city_region.dart';
import 'package:decorated_flutter/src/ui/widget/visual/preferred/city_picker.dialog.dart';
import 'package:cupertino_ui/cupertino_ui.dart' show CupertinoPicker;
import 'package:material_ui/material_ui.dart'
    show MaterialApp, Scaffold, Text, TextButton;
import 'package:flutter_test/flutter_test.dart';

void main() {
  const data = [
    CityRegion(
      code: '2',
      name: '乙省',
      children: [
        CityRegion(
          code: '21',
          name: '乙市',
          children: [
            CityRegion(code: '211', name: '甲区'),
            CityRegion(code: '212', name: '乙区'),
          ],
        ),
      ],
    ),
  ];

  for (final showArea in [true, false]) {
    testWidgets('显示并返回 showArea=$showArea 时的选择', (tester) async {
      CityPickerResult? result;
      await tester.pumpWidget(
        MaterialApp(
          home: Scaffold(
            body: TextButton(
              onPressed: () async {
                result = await showCityPickerDialog(
                  tester.element(find.text('选择城市')),
                  data: data,
                  initialProvinceCode: '2',
                  initialAreaCode: '212',
                  showArea: showArea,
                );
              },
              child: const Text('选择城市'),
            ),
          ),
        ),
      );

      await tester.tap(find.text('选择城市'));
      await tester.pumpAndSettle();

      expect(find.byType(CupertinoPicker), findsNWidgets(showArea ? 3 : 2));
      expect(find.text('乙省'), findsOneWidget);
      expect(find.text('乙市'), findsOneWidget);

      await tester.tap(find.text('确定'));
      await tester.pumpAndSettle();

      expect(result?.codes, ['2', '21', showArea ? '212' : '211']);
    });
  }
}
