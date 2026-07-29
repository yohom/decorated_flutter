import 'package:decorated_flutter/src/ui/widget/visual/special_affect/overflow_text.widget.dart';
import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';

void main() {
  const overflowWidgetKey = Key('overflow-widget');

  Widget buildApp(String text, {VoidCallback? onPressed}) {
    return MaterialApp(
      home: Scaffold(
        body: SizedBox(
          width: 120,
          child: OverflowText(
            text,
            maxLines: 1,
            overflowWidget: TextButton(
              key: overflowWidgetKey,
              onPressed: onPressed,
              child: const Text('全文'),
            ),
          ),
        ),
      ),
    );
  }

  testWidgets('文本未溢出时不展示尾部组件', (tester) async {
    await tester.pumpWidget(buildApp('短文本'));
    await tester.pump();

    expect(find.byKey(overflowWidgetKey), findsNothing);
    expect(find.text('短文本'), findsOneWidget);
  });

  testWidgets('文本溢出时展示可点击的尾部组件', (tester) async {
    var pressed = false;
    await tester.pumpWidget(
      buildApp('这是一段足够长的文本，用于验证自定义尾部组件是否会显示。', onPressed: () {
        pressed = true;
      }),
    );
    await tester.pump();

    expect(find.byKey(overflowWidgetKey), findsOneWidget);
    expect(
      find.byWidgetPredicate(
        (widget) =>
            widget is RichText && widget.text.toPlainText().contains('…'),
      ),
      findsOneWidget,
    );

    await tester.tap(find.byKey(overflowWidgetKey));
    expect(pressed, isTrue);
  });

  testWidgets('极窄宽度时优先展示可点击的尾部组件', (tester) async {
    var pressed = false;
    await tester.pumpWidget(
      MaterialApp(
        home: Scaffold(
          body: SizedBox(
            width: 20,
            child: OverflowText(
              '这是一段足够长的文本',
              overflowWidget: TextButton(
                key: overflowWidgetKey,
                onPressed: () => pressed = true,
                child: const Text('全文'),
              ),
            ),
          ),
        ),
      ),
    );
    await tester.pump();

    expect(find.byKey(overflowWidgetKey), findsOneWidget);
    await tester.tap(find.byKey(overflowWidgetKey));
    expect(pressed, isTrue);
  });

  testWidgets('不会截断组合 emoji', (tester) async {
    await tester.pumpWidget(buildApp('👍🏽👍🏽👍🏽👍🏽'));
    await tester.pump();

    final richText = tester.widget<RichText>(find.byType(RichText).first);
    expect(richText.text.toPlainText(), isNot(contains('👍…')));
  });
}
