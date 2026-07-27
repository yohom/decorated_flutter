import 'package:decorated_flutter/src/ui/route/hero_dialog.overlay.dart';
import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';

void main() {
  testWidgets('共享元素在关闭弹窗后恢复源组件显示', (tester) async {
    HeroOverlay<void>? overlay;
    const sourceKey = Key('source-hero');

    await tester.pumpWidget(
      MaterialApp(
        home: Scaffold(
          body: HeroOverlayScope(
            child: Builder(
              builder: (context) {
                return Column(
                  children: [
                    const OverlayHero(
                      tag: 'order',
                      child: SizedBox(key: sourceKey, width: 80, height: 80),
                    ),
                    TextButton(
                      onPressed: () {
                        overlay = showHeroOverlay<void>(
                          context,
                          transitionDuration: const Duration(milliseconds: 100),
                          reverseTransitionDuration:
                              const Duration(milliseconds: 100),
                          builder: (_) => const OverlayHero(
                            tag: 'order',
                            child: SizedBox(
                              key: Key('target-hero'),
                              width: 160,
                              height: 160,
                            ),
                          ),
                        );
                      },
                      child: const Text('打开弹窗'),
                    ),
                  ],
                );
              },
            ),
          ),
        ),
      ),
    );

    await tester.tap(find.text('打开弹窗'));
    await tester.pump();
    await tester.pump();

    final sourceOpacity = find.ancestor(
      of: find.byKey(sourceKey),
      matching: find.byType(Opacity),
    );
    expect(tester.widget<Opacity>(sourceOpacity).opacity, 0);

    await tester.pumpAndSettle();
    final targetOpacity = find.ancestor(
      of: find.byKey(const Key('target-hero')),
      matching: find.byType(Opacity),
    );
    expect(tester.widget<Opacity>(targetOpacity.first).opacity, 1);

    overlay!.dismiss();
    await tester.pumpAndSettle();

    expect(tester.widget<Opacity>(sourceOpacity).opacity, 1);
    await overlay!.closed;
    expect(tester.takeException(), isNull);
  });

  testWidgets('未配置 Scope 时仍可正常打开和关闭弹窗', (tester) async {
    HeroOverlay<void>? overlay;

    await tester.pumpWidget(
      MaterialApp(
        home: Scaffold(
          body: Builder(
            builder: (context) {
              return TextButton(
                onPressed: () {
                  overlay = showHeroOverlay<void>(
                    context,
                    builder: (_) => const Text('弹窗内容'),
                  );
                },
                child: const Text('打开普通弹窗'),
              );
            },
          ),
        ),
      ),
    );

    await tester.tap(find.text('打开普通弹窗'));
    await tester.pumpAndSettle();
    expect(find.text('弹窗内容'), findsOneWidget);

    overlay!.dismiss();
    await tester.pumpAndSettle();

    await overlay!.closed;
    expect(tester.takeException(), isNull);
  });
}
