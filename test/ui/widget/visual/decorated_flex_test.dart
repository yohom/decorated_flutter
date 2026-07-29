import 'package:decorated_flutter/src/model/flex_config.dart';
import 'package:decorated_flutter/src/ui/widget/visual/decorated/decorated_flex.widget.dart';
import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';

void main() {
  testWidgets('DecoratedRow 使用 Flutter 内置 spacing 排列子项', (tester) async {
    await tester.pumpWidget(
      const Directionality(
        textDirection: TextDirection.ltr,
        child: DecoratedRow(
          spacing: 12,
          mainAxisSize: MainAxisSize.min,
          children: [
            SizedBox(key: Key('first'), width: 10, height: 10),
            SizedBox(key: Key('second'), width: 10, height: 10),
          ],
        ),
      ),
    );

    expect(tester.getTopLeft(find.byKey(const Key('second'))).dx, 22);
  });

  testWidgets('DecoratedColumn 的 itemSpacing 保持兼容', (tester) async {
    await tester.pumpWidget(
      const Directionality(
        textDirection: TextDirection.ltr,
        child: DecoratedColumn(
          itemSpacing: 8,
          mainAxisSize: MainAxisSize.min,
          children: [
            SizedBox(key: Key('first'), width: 10, height: 10),
            SizedBox(key: Key('second'), width: 10, height: 10),
          ],
        ),
      ),
    );

    expect(tester.getTopLeft(find.byKey(const Key('second'))).dy, 18);
  });

  testWidgets('reverse 后 spacing 保持在相邻子项之间', (tester) async {
    await tester.pumpWidget(
      const Directionality(
        textDirection: TextDirection.ltr,
        child: Align(
          alignment: Alignment.topLeft,
          child: DecoratedRow(
            reverse: true,
            spacing: 4,
            mainAxisSize: MainAxisSize.min,
            children: [
              SizedBox(key: Key('first'), width: 10, height: 10),
              SizedBox(key: Key('second'), width: 10, height: 10),
            ],
          ),
        ),
      ),
    );

    expect(tester.getTopLeft(find.byKey(const Key('second'))).dx, 0);
    expect(tester.getTopLeft(find.byKey(const Key('first'))).dx, 14);
  });

  testWidgets('childrenFlex 会扣除 spacing 后分配剩余宽度', (tester) async {
    await tester.pumpWidget(
      const Directionality(
        textDirection: TextDirection.ltr,
        child: Align(
          alignment: Alignment.topLeft,
          child: DecoratedRow(
            width: 100,
            spacing: 8,
            childrenFlex: FlexConfig.expanded(),
            children: [
              SizedBox(key: Key('first'), height: 10),
              SizedBox(key: Key('second'), height: 10),
            ],
          ),
        ),
      ),
    );

    expect(tester.getSize(find.byKey(const Key('first'))).width, 46);
    expect(tester.getTopLeft(find.byKey(const Key('second'))).dx, 54);
  });

  testWidgets('divider 保持优先于 spacing', (tester) async {
    await tester.pumpWidget(
      const Directionality(
        textDirection: TextDirection.ltr,
        child: DecoratedColumn(
          spacing: 8,
          divider: SizedBox(height: 3),
          mainAxisSize: MainAxisSize.min,
          children: [
            SizedBox(key: Key('first'), width: 10, height: 10),
            SizedBox(key: Key('second'), width: 10, height: 10),
          ],
        ),
      ),
    );

    expect(tester.getTopLeft(find.byKey(const Key('second'))).dy, 13);
  });
}
