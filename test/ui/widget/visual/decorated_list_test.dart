import 'package:decorated_flutter/src/ui/widget/visual/decorated/decorated_list.widget.dart';
import 'package:decorated_flutter/src/ui/widget/visual/decorated/decorated_scrollable.widget.dart';
import 'package:decorated_flutter/src/ui/widget/visual/decorated/load_more.widget.dart';
import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';

void main() {
  testWidgets('box列表接近底部时触发一次加载更多并展示没有更多占位', (tester) async {
    var loadMoreCount = 0;

    await tester.pumpWidget(
      MaterialApp(
        home: SizedBox(
          height: 100,
          child: DecoratedList.box(
            itemCount: 3,
            itemBuilder: (_, index) => SizedBox(
              height: 60,
              child: Text('$index'),
            ),
            loadMoreConfig: LoadMoreConfig(
              onLoadMore: () async {
                loadMoreCount++;
                return false;
              },
              loadMoreTriggerExtent: 60,
              noMoreDataPlaceholder: const SizedBox(
                key: Key('no-more'),
                height: 40,
                child: Text('到底了'),
              ),
            ),
          ),
        ),
      ),
    );

    await tester.pump();
    expect(loadMoreCount, 0);

    await tester.drag(find.byType(ListView), const Offset(0, -50));
    await tester.pumpAndSettle();

    expect(loadMoreCount, 1);
    expect(find.byKey(const Key('no-more')), findsOneWidget);
    expect(find.text('到底了'), findsOneWidget);
  });

  testWidgets('sliver列表不处理loadmore状态和占位', (tester) async {
    await tester.pumpWidget(
      MaterialApp(
        home: SizedBox(
          height: 100,
          child: CustomScrollView(
            slivers: [
              DecoratedList.sliver(
                itemCount: 3,
                itemBuilder: (_, index) => SizedBox(
                  height: 60,
                  child: Text('$index'),
                ),
              ),
            ],
          ),
        ),
      ),
    );

    await tester.pump();
    expect(find.text('没有更多数据'), findsNothing);
  });

  testWidgets('LoadMoreConfig使用全局没有更多占位', (tester) async {
    final originalPlaceholder = LoadMoreConfig.defaultNoMoreDataPlaceholder;
    addTearDown(
      () => LoadMoreConfig.setDefaultNoMoreDataPlaceholder(originalPlaceholder),
    );
    LoadMoreConfig.setDefaultNoMoreDataPlaceholder(
      const SizedBox(key: Key('global-no-more'), height: 40),
    );

    await tester.pumpWidget(
      MaterialApp(
        home: SizedBox(
          height: 100,
          child: DecoratedList.box(
            itemCount: 3,
            itemBuilder: (_, index) => SizedBox(
              height: 60,
              child: Text('$index'),
            ),
            loadMoreConfig: LoadMoreConfig(
              onLoadMore: () async => false,
            ),
          ),
        ),
      ),
    );

    await tester.drag(find.byType(ListView), const Offset(0, -200));
    await tester.pumpAndSettle();

    expect(find.byKey(const Key('global-no-more')), findsOneWidget);
  });

  testWidgets('LoadMore可以包裹自定义CustomScrollView', (tester) async {
    var loadMoreCount = 0;
    final config = LoadMoreConfig(
      loadMoreTriggerExtent: 60,
      onLoadMore: () async {
        loadMoreCount++;
        return false;
      },
      noMoreDataPlaceholder: const SizedBox(
        key: Key('custom-scroll-view-no-more'),
        height: 40,
      ),
    );

    await tester.pumpWidget(
      MaterialApp(
        home: SizedBox(
          height: 100,
          child: LoadMore(
            config: config,
            builder: (_, hasMoreData) => CustomScrollView(
              slivers: [
                SliverList(
                  delegate: SliverChildBuilderDelegate(
                    (_, index) => SizedBox(height: 60, child: Text('$index')),
                    childCount: 3,
                  ),
                ),
                if (!hasMoreData)
                  SliverToBoxAdapter(
                    child: config.effectiveNoMoreDataPlaceholder,
                  ),
              ],
            ),
          ),
        ),
      ),
    );

    await tester.drag(find.byType(CustomScrollView), const Offset(0, -50));
    await tester.pumpAndSettle();

    expect(loadMoreCount, 1);
    expect(find.byKey(const Key('custom-scroll-view-no-more')), findsOneWidget);
  });

  testWidgets('DecoratedScrollable可以集成LoadMore', (tester) async {
    var loadMoreCount = 0;

    await tester.pumpWidget(
      MaterialApp(
        home: SizedBox(
          height: 100,
          child: DecoratedScrollable(
            loadMoreConfig: LoadMoreConfig(
              loadMoreTriggerExtent: 60,
              onLoadMore: () async {
                loadMoreCount++;
                return false;
              },
            ),
            child: CustomScrollView(
              slivers: [
                SliverList(
                  delegate: SliverChildBuilderDelegate(
                    (_, index) => SizedBox(height: 60, child: Text('$index')),
                    childCount: 3,
                  ),
                ),
              ],
            ),
          ),
        ),
      ),
    );

    await tester.drag(find.byType(CustomScrollView), const Offset(0, -50));
    await tester.pumpAndSettle();

    expect(loadMoreCount, 1);
  });
}
