import 'package:decorated_flutter/src/ui/widget/visual/special_affect/keyboard_height_builder.widget.dart';
import 'package:decorated_flutter/src/utils/objects.dart';
import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:shared_preferences/shared_preferences.dart';

double get _cachedKeyboardHeight {
  return gDecoratedStorage.getDouble('decorated_flutter.keyboardHeight') ?? 0;
}

void main() {
  setUp(() async {
    SharedPreferences.setMockInitialValues({
      'decorated_flutter.keyboardHeight': 180.0,
    });
    await initDecoratedBox();
  });

  testWidgets(
      'KeyboardHeightBuilder uses cached height first and updates to realtime value',
      (tester) async {
    tester.view.devicePixelRatio = 1;
    tester.view.viewInsets = const FakeViewPadding(bottom: 0);
    addTearDown(() {
      tester.view.viewInsets = const FakeViewPadding(bottom: 0);
      tester.view.resetDevicePixelRatio();
    });

    await tester.pumpWidget(
      MaterialApp(
        home: KeyboardHeightBuilder(
          builder: (keyboardHeight, stableKeyboardHeight) {
            return Text(
              '${keyboardHeight.toStringAsFixed(0)}/${stableKeyboardHeight.toStringAsFixed(0)}',
              textDirection: TextDirection.ltr,
            );
          },
        ),
      ),
    );

    expect(find.text('180/180'), findsOneWidget);
    expect(_cachedKeyboardHeight, 180);

    tester.view.viewInsets = const FakeViewPadding(bottom: 216);
    await tester.pump();

    expect(find.text('216/180'), findsOneWidget);
  });

  testWidgets(
      'KeyboardHeightBuilder updates stableKeyboardHeight after debounce and persists it',
      (tester) async {
    tester.view.devicePixelRatio = 1;
    tester.view.viewInsets = const FakeViewPadding(bottom: 0);
    addTearDown(() {
      tester.view.viewInsets = const FakeViewPadding(bottom: 0);
      tester.view.resetDevicePixelRatio();
    });

    await tester.pumpWidget(
      MaterialApp(
        home: KeyboardHeightBuilder(
          builder: (keyboardHeight, stableKeyboardHeight) {
            return Column(
              children: [
                Text(
                  'keyboard:${keyboardHeight.toStringAsFixed(0)}',
                  textDirection: TextDirection.ltr,
                ),
                Text(
                  'stable:${stableKeyboardHeight.toStringAsFixed(0)}',
                  textDirection: TextDirection.ltr,
                ),
              ],
            );
          },
        ),
      ),
    );

    expect(find.text('keyboard:180'), findsOneWidget);
    expect(find.text('stable:180'), findsOneWidget);

    tester.view.viewInsets = const FakeViewPadding(bottom: 216);
    await tester.pump();

    expect(find.text('keyboard:216'), findsOneWidget);
    expect(find.text('stable:180'), findsOneWidget);
    expect(_cachedKeyboardHeight, 180);

    await tester.pump(const Duration(milliseconds: 200));

    expect(find.text('keyboard:216'), findsOneWidget);
    expect(find.text('stable:216'), findsOneWidget);
    expect(_cachedKeyboardHeight, 216);

    tester.view.viewInsets = const FakeViewPadding(bottom: 0.4);
    await tester.pump();

    expect(find.text('keyboard:0'), findsOneWidget);
    expect(find.text('stable:216'), findsOneWidget);

    await tester.pump(const Duration(milliseconds: 200));

    expect(find.text('stable:216'), findsOneWidget);
    expect(_cachedKeyboardHeight, 216);
  });
}
