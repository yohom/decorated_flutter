import 'dart:async';

import 'package:decorated_flutter/decorated_flutter.dart';
import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';

void main() {
  testWidgets('立即失败的 Future 清理 loading Overlay 后不再拦截点击', (
    tester,
  ) async {
    var targetTapCount = 0;
    const triggerKey = Key('trigger_loading');
    const targetKey = Key('target_button');

    await tester.pumpWidget(
      MaterialApp(
        navigatorKey: gNavigatorKey,
        home: Column(
          children: [
            TextButton(
              key: triggerKey,
              onPressed: () {
                unawaited(
                  Future<void>.error('校验失败').loading().catchError((_) {}),
                );
              },
              child: const Text('触发 loading'),
            ),
            TextButton(
              key: targetKey,
              onPressed: () => targetTapCount += 1,
              child: const Text('目标按钮'),
            ),
          ],
        ),
      ),
    );

    await tester.tap(find.byKey(triggerKey));
    await tester.pump();
    await tester.pump(const Duration(milliseconds: 200));

    expect(find.byType(ModalLoading), findsNothing);

    await tester.tap(find.byKey(targetKey));
    expect(targetTapCount, 1);
  });
}
