import 'package:decorated_flutter/src/ui/widget/visual/special_affect/keyboard_height.widget.dart';
import 'package:decorated_flutter/src/utils/objects.dart';
import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:shared_preferences/shared_preferences.dart';

void main() {
  setUp(() async {
    SharedPreferences.setMockInitialValues({});
    await initDecoratedBox();
  });

  testWidgets('KeyboardHeightObserver persists stable keyboard height',
      (tester) async {
    tester.view.devicePixelRatio = 1;
    tester.view.viewInsets = const FakeViewPadding(bottom: 0);
    addTearDown(() {
      tester.view.viewInsets = const FakeViewPadding(bottom: 0);
      tester.view.resetDevicePixelRatio();
    });

    await tester.pumpWidget(
      const MaterialApp(
        home: KeyboardHeightObserver(
          child: SizedBox.expand(),
        ),
      ),
    );

    expect(KeyboardHeightObserver.height, 0);

    tester.view.viewInsets = const FakeViewPadding(bottom: 216);
    await tester.pump();
    await tester.pump(const Duration(milliseconds: 200));

    expect(KeyboardHeightObserver.height, 216);
  });
}
