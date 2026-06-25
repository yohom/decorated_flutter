import 'package:decorated_flutter/src/model/close_keyboard_config.dart';
import 'package:decorated_flutter/src/ui/widget/nonvisual/auto_close_keyboard.widget.dart';
import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';

void main() {
  testWidgets('inner disabled AutoCloseKeyboard blocks outer config',
      (tester) async {
    final focusNode = FocusNode();
    addTearDown(focusNode.dispose);

    var outerClosedCount = 0;
    const containerKey = ValueKey('keyboard-scope');

    await tester.pumpWidget(
      MaterialApp(
        home: Scaffold(
          body: Center(
            child: SizedBox(
              key: containerKey,
              width: 300,
              height: 200,
              child: AutoCloseKeyboard(
                config: CloseKeyboardConfig(
                  onKeyboardClosed: () => outerClosedCount++,
                ),
                child: AutoCloseKeyboard(
                  config: const CloseKeyboardConfig(enabled: false),
                  child: _KeyboardTestBody(focusNode: focusNode),
                ),
              ),
            ),
          ),
        ),
      ),
    );

    await tester.tap(find.byType(TextField));
    await tester.pump();
    expect(focusNode.hasFocus, isTrue);

    final boxRect = tester.getRect(find.byKey(containerKey));
    await tester.tapAt(boxRect.bottomCenter - const Offset(0, 8));
    await tester.pump();

    expect(outerClosedCount, 0);
    expect(focusNode.hasFocus, isTrue);
  });

  testWidgets('inner AutoCloseKeyboard config takes precedence over outer',
      (tester) async {
    final focusNode = FocusNode();
    addTearDown(focusNode.dispose);

    var outerClosedCount = 0;
    var innerClosedCount = 0;
    const containerKey = ValueKey('keyboard-scope');

    await tester.pumpWidget(
      MaterialApp(
        home: Scaffold(
          body: Center(
            child: SizedBox(
              key: containerKey,
              width: 300,
              height: 200,
              child: AutoCloseKeyboard(
                config: CloseKeyboardConfig(
                  onKeyboardClosed: () => outerClosedCount++,
                ),
                child: AutoCloseKeyboard(
                  config: CloseKeyboardConfig(
                    clearFocus: false,
                    onKeyboardClosed: () => innerClosedCount++,
                  ),
                  child: _KeyboardTestBody(focusNode: focusNode),
                ),
              ),
            ),
          ),
        ),
      ),
    );

    await tester.tap(find.byType(TextField));
    await tester.pump();
    expect(focusNode.hasFocus, isTrue);

    final boxRect = tester.getRect(find.byKey(containerKey));
    await tester.tapAt(boxRect.bottomCenter - const Offset(0, 8));
    await tester.pump();

    expect(innerClosedCount, 1);
    expect(outerClosedCount, 0);
    expect(focusNode.hasFocus, isTrue);
  });
}

class _KeyboardTestBody extends StatelessWidget {
  const _KeyboardTestBody({this.focusNode});

  final FocusNode? focusNode;

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        TextField(focusNode: focusNode),
        const Expanded(child: SizedBox()),
      ],
    );
  }
}
