import 'package:decorated_flutter/src/ui/sliver/sliver_clip.sliver.dart';
import 'package:flutter/widgets.dart';
import 'package:flutter_test/flutter_test.dart';

void main() {
  testWidgets('SliverClip stores and updates rounded clip configuration',
      (tester) async {
    const key = ValueKey('sliver-clip');

    await tester.pumpWidget(
      const Directionality(
        textDirection: TextDirection.ltr,
        child: CustomScrollView(
          slivers: [
            SliverClip(
              key: key,
              borderRadius: BorderRadius.all(Radius.circular(12)),
              child: SliverToBoxAdapter(
                child: SizedBox(height: 100),
              ),
            ),
          ],
        ),
      ),
    );

    dynamic renderObject = tester.renderObject(find.byKey(key));
    expect(
      renderObject.borderRadius,
      const BorderRadius.all(Radius.circular(12)),
    );
    expect(renderObject.clipBehavior, isNull);
    expect(renderObject.clipRect, isNotNull);

    await tester.pumpWidget(
      const Directionality(
        textDirection: TextDirection.rtl,
        child: CustomScrollView(
          slivers: [
            SliverClip(
              key: key,
              clipBehavior: Clip.none,
              child: SliverToBoxAdapter(
                child: SizedBox(height: 100),
              ),
            ),
          ],
        ),
      ),
    );

    renderObject = tester.renderObject(find.byKey(key));
    expect(renderObject.borderRadius, BorderRadius.zero);
    expect(renderObject.clipBehavior, Clip.none);
    expect(renderObject.textDirection, TextDirection.rtl);
  });

  testWidgets('SliverClip resolves directional border radius', (tester) async {
    const key = ValueKey('directional-sliver-clip');

    await tester.pumpWidget(
      const Directionality(
        textDirection: TextDirection.rtl,
        child: CustomScrollView(
          slivers: [
            SliverClip(
              key: key,
              borderRadius: BorderRadiusDirectional.only(
                topStart: Radius.circular(8),
              ),
              child: SliverToBoxAdapter(
                child: SizedBox(height: 100),
              ),
            ),
          ],
        ),
      ),
    );

    final dynamic renderObject = tester.renderObject(find.byKey(key));
    expect(
      renderObject.borderRadius.resolve(renderObject.textDirection),
      const BorderRadius.only(topRight: Radius.circular(8)),
    );
  });
}
