import 'package:decorated_flutter/src/ui/widget/visual/special_affect/countdown.widget.dart';
import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';

void main() {
  Widget buildCountdown(
    int initialData,
    Duration interval, {
    VoidCallback? onZero,
  }) {
    return MaterialApp(
      home: Scaffold(
        body: Countdown(
          key: const ValueKey('countdown'),
          initialData: initialData,
          interval: interval,
          builder: (_, count) => Text('$count'),
          onZero: onZero,
        ),
      ),
    );
  }

  testWidgets('更新初始值和间隔后重启倒计时', (tester) async {
    await tester.pumpWidget(
      buildCountdown(5, const Duration(seconds: 1)),
    );
    await tester.pump(const Duration(seconds: 1));
    expect(find.text('4'), findsOneWidget);

    await tester.pumpWidget(
      buildCountdown(8, const Duration(milliseconds: 100)),
    );
    expect(find.text('8'), findsOneWidget);

    await tester.pump(const Duration(milliseconds: 100));
    expect(find.text('7'), findsOneWidget);
  });

  testWidgets('新倒计时在上一次归零后仍会触发归零回调', (tester) async {
    var zeroCount = 0;
    const interval = Duration(milliseconds: 100);

    await tester.pumpWidget(
      buildCountdown(1, interval, onZero: () => zeroCount++),
    );
    await tester.pump(interval);
    expect(zeroCount, 1);

    await tester.pumpWidget(
      buildCountdown(2, interval, onZero: () => zeroCount++),
    );
    await tester.pump(interval);
    await tester.pump(interval);

    expect(zeroCount, 2);
  });
}
