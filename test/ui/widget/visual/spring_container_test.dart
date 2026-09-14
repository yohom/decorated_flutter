import 'package:decorated_flutter/src/ui/widget/visual/decorated/buttons.widget.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:flutter/widgets.dart';

void main() {
  testWidgets('按下时缩小，松开后立即使用弹簧回弹并触发回调', (tester) async {
    var pressCount = 0;
    await tester.pumpWidget(
      Directionality(
        textDirection: TextDirection.ltr,
        child: Center(
          child: SpringContainer(
            debounceDuration: Duration.zero,
            onPressed: (_) => pressCount++,
            child: const SizedBox(
              key: Key('spring-button'),
              width: 100,
              height: 100,
            ),
          ),
        ),
      ),
    );

    final gesture = await tester.startGesture(
      tester.getCenter(find.byKey(const Key('spring-button'))),
    );
    await tester.pump(const Duration(milliseconds: 80));

    final pressedScale = _scaleOf(tester);
    expect(pressedScale, lessThan(1));
    expect(pressedScale, greaterThan(0.95));

    await gesture.up();
    await tester.pump(const Duration(milliseconds: 50));

    expect(_scaleOf(tester), greaterThan(pressedScale));
    expect(pressCount, 1);

    await tester.pumpAndSettle();
    expect(_scaleOf(tester), closeTo(1, 0.001));
  });

  testWidgets('移出按钮后取消按压，重新移入后仍可触发点击', (tester) async {
    var pressCount = 0;
    await tester.pumpWidget(
      Directionality(
        textDirection: TextDirection.ltr,
        child: Center(
          child: SpringContainer(
            debounceDuration: Duration.zero,
            onPressed: (_) => pressCount++,
            child: const SizedBox(
              key: Key('spring-button'),
              width: 100,
              height: 100,
            ),
          ),
        ),
      ),
    );

    final center = tester.getCenter(find.byKey(const Key('spring-button')));
    final gesture = await tester.startGesture(center);
    await tester.pump(const Duration(milliseconds: 80));

    await gesture.moveTo(center + const Offset(100, 0));
    await tester.pump(const Duration(milliseconds: 80));
    expect(_scaleOf(tester), greaterThan(0.95));

    await gesture.moveTo(center);
    await tester.pump(const Duration(milliseconds: 120));
    expect(_scaleOf(tester), lessThan(1));

    await gesture.up();
    await tester.pumpAndSettle();

    expect(pressCount, 1);
    expect(_scaleOf(tester), closeTo(1, 0.001));
  });

  testWidgets('移出后松手不会触发回调', (tester) async {
    var pressCount = 0;
    await tester.pumpWidget(
      Directionality(
        textDirection: TextDirection.ltr,
        child: Center(
          child: SpringContainer(
            debounceDuration: Duration.zero,
            onPressed: (_) => pressCount++,
            child: const SizedBox(
              key: Key('spring-button'),
              width: 100,
              height: 100,
            ),
          ),
        ),
      ),
    );

    final center = tester.getCenter(find.byKey(const Key('spring-button')));
    final gesture = await tester.startGesture(center);
    await tester.pump(const Duration(milliseconds: 80));
    await gesture.moveTo(center + const Offset(100, 0));
    await gesture.up();
    await tester.pumpAndSettle();

    expect(pressCount, 0);
    expect(_scaleOf(tester), closeTo(1, 0.001));
  });

  testWidgets('防抖期间视觉效果仍响应但只触发一次回调', (tester) async {
    var pressCount = 0;
    await tester.pumpWidget(
      Directionality(
        textDirection: TextDirection.ltr,
        child: Center(
          child: SpringContainer(
            debounceDuration: const Duration(milliseconds: 800),
            onPressed: (_) => pressCount++,
            child: const SizedBox(
              key: Key('spring-button'),
              width: 100,
              height: 100,
            ),
          ),
        ),
      ),
    );

    final button = find.byType(RawGestureDetector);
    await tester.tap(button);
    await tester.pumpAndSettle();
    await tester.tap(button);
    await tester.pumpAndSettle();

    expect(pressCount, 1);
    await tester.pump(const Duration(milliseconds: 800));
  });
}

double _scaleOf(WidgetTester tester) {
  final transform = tester.widget<Transform>(find.byType(Transform));
  return transform.transform.storage[0];
}
