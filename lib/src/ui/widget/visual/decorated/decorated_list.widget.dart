import 'package:flutter/material.dart';
import 'package:flutter/rendering.dart' show ItemExtentBuilder;

import 'decorated_scrollable.widget.dart';
import 'load_more.widget.dart';
import 'scrollable_top_divider.widget.dart';

class DecoratedList extends StatelessWidget {
  const DecoratedList.box({
    super.key,
    this.padding,
    this.restorationId,
    this.shrinkWrap = false,
    this.itemBuilder,
    this.itemCount,
    this.children,
    this.keyboardDismissBehavior = ScrollViewKeyboardDismissBehavior.onDrag,
    this.scrollDirection,
    this.width,
    this.height,
    this.addAutomaticKeepAlives = true,
    this.addRepaintBoundaries = true,
    this.addSemanticIndexes = true,
    this.itemExtent,
    this.itemExtentBuilder,
    this.prototypeItem,
    this.controller,
    this.expanded,
    this.decoration,
    this.physics,
    this.clipBehavior = Clip.hardEdge,
    this.reverse = false,
    @Deprecated('使用decoratedScrollableConfig代替, 已无作用') this.topDivider,
    this.decoratedScrollableConfig,
    this.margin,
    this.loadMoreConfig,
  })  : assert(
          (itemExtent == null && prototypeItem == null) ||
              (itemExtent == null && itemExtentBuilder == null) ||
              (prototypeItem == null && itemExtentBuilder == null),
          'You can only pass one of itemExtent, prototypeItem and itemExtentBuilder.',
        ),
        _sliver = false,
        separatorBuilder = null;

  const DecoratedList.boxSeparated({
    super.key,
    this.padding,
    this.restorationId,
    this.shrinkWrap = false,
    this.itemBuilder,
    required this.itemCount,
    this.keyboardDismissBehavior = ScrollViewKeyboardDismissBehavior.onDrag,
    this.scrollDirection,
    this.width,
    this.height,
    this.addAutomaticKeepAlives = true,
    this.addRepaintBoundaries = true,
    this.addSemanticIndexes = true,
    this.controller,
    this.expanded,
    this.decoration,
    required this.separatorBuilder,
    this.physics,
    this.reverse = false,
    this.clipBehavior = Clip.hardEdge,
    @Deprecated('使用decoratedScrollableConfig代替, 已无作用') this.topDivider,
    this.decoratedScrollableConfig,
    this.margin,
    this.loadMoreConfig,
  })  : assert(itemCount != null),
        assert(separatorBuilder != null),
        _sliver = false,
        itemExtent = null,
        itemExtentBuilder = null,
        prototypeItem = null,
        children = null;

  const DecoratedList.sliver({
    super.key,
    this.padding,
    this.itemBuilder,
    this.itemCount,
    this.children,
    this.width,
    this.height,
    this.addAutomaticKeepAlives = true,
    this.addRepaintBoundaries = true,
    this.addSemanticIndexes = true,
    this.itemExtent,
    this.itemExtentBuilder,
    this.prototypeItem,
  })  : assert(
          (itemExtent == null && prototypeItem == null) ||
              (itemExtent == null && itemExtentBuilder == null) ||
              (prototypeItem == null && itemExtentBuilder == null),
          'You can only pass one of itemExtent, prototypeItem and itemExtentBuilder.',
        ),
        _sliver = true,
        shrinkWrap = false,
        scrollDirection = null,
        controller = null,
        separatorBuilder = null,
        restorationId = null,
        expanded = null,
        physics = null,
        reverse = false,
        decoration = null,
        clipBehavior = Clip.none,
        keyboardDismissBehavior = ScrollViewKeyboardDismissBehavior.onDrag,
        topDivider = null,
        decoratedScrollableConfig = null,
        margin = null,
        loadMoreConfig = null;

  final bool _sliver;
  final String? restorationId;
  final EdgeInsets? padding, margin;
  final bool shrinkWrap;
  final IndexedWidgetBuilder? itemBuilder;
  final int? itemCount;
  final ScrollViewKeyboardDismissBehavior keyboardDismissBehavior;
  final Axis? scrollDirection;
  final List<Widget>? children;
  final double? width, height;
  final bool addAutomaticKeepAlives, addRepaintBoundaries, addSemanticIndexes;
  final double? itemExtent;
  final ItemExtentBuilder? itemExtentBuilder;
  final Widget? prototypeItem;
  final ScrollController? controller;
  final bool? expanded;
  final IndexedWidgetBuilder? separatorBuilder;
  final BoxDecoration? decoration;
  final ScrollPhysics? physics;
  final bool reverse;
  final Clip clipBehavior;

  /// 滚动时是否显示顶部的分割线
  @Deprecated('使用decoratedScrollableConfig代替, 已无作用')
  final TopDividerConfig? topDivider;

  /// 滚动decoration
  final DecoratedScrollableConfig? decoratedScrollableConfig;

  /// box列表的加载更多配置。sliver版本不处理加载更多。
  final LoadMoreConfig? loadMoreConfig;

  @override
  Widget build(BuildContext context) {
    Widget result = _sliver ? _sliverList() : _boxList();

    if (width != null || height != null) {
      result = SizedBox(width: width, height: height, child: result);
    }

    if (decoration != null || margin != null) {
      result = Container(
        clipBehavior: clipBehavior,
        decoration: decoration,
        margin: margin,
        child: result,
      );
    }

    if (decoratedScrollableConfig != null) {
      result = DecoratedScrollable(
        config: decoratedScrollableConfig!,
        child: result,
      );
    }

    if (expanded == true) {
      result = Expanded(child: result);
    }

    return result;
  }

  Widget _sliverList() {
    final baseItemCount = _itemCount;

    final delegate = SliverChildBuilderDelegate(
      (context, index) {
        if (children != null) return children![index];
        if (itemBuilder != null) return itemBuilder!(context, index);
        throw '必须传入children或itemBuilder';
      },
      childCount: baseItemCount,
      addAutomaticKeepAlives: addAutomaticKeepAlives,
      addRepaintBoundaries: addRepaintBoundaries,
      addSemanticIndexes: addSemanticIndexes,
    );

    Widget result = prototypeItem != null
        ? SliverPrototypeExtentList(
            delegate: delegate,
            prototypeItem: prototypeItem!,
          )
        : itemExtentBuilder != null
            ? SliverVariedExtentList(
                delegate: delegate,
                itemExtentBuilder: itemExtentBuilder!,
              )
            : itemExtent != null
                ? SliverFixedExtentList(
                    delegate: delegate, itemExtent: itemExtent!)
                : SliverList(delegate: delegate);

    if (padding != null) {
      result = SliverPadding(padding: padding!, sliver: result);
    }
    return result;
  }

  Widget _boxList() {
    final config = loadMoreConfig;
    if (config == null) return _boxListContent(hasMoreData: true);

    return LoadMore(
      config: config,
      reverse: reverse,
      builder: (_, hasMoreData) => _boxListContent(hasMoreData: hasMoreData),
    );
  }

  Widget _boxListContent({required bool hasMoreData}) {
    final showNoMoreData = !hasMoreData && _noMoreDataPlaceholder != null;
    Widget result;

    if (children != null) {
      final listChildren = <Widget>[
        ...children!,
        if (showNoMoreData) _noMoreDataPlaceholder!,
      ];
      result = ListView(
        padding: padding,
        keyboardDismissBehavior: keyboardDismissBehavior,
        restorationId: restorationId,
        controller: controller,
        shrinkWrap: shrinkWrap,
        itemExtent: itemExtent,
        itemExtentBuilder: _itemExtentBuilderWithPlaceholder(
          itemExtentBuilder,
          baseItemCount: children!.length,
          showNoMoreData: showNoMoreData,
        ),
        physics: physics,
        reverse: reverse,
        scrollDirection: scrollDirection ?? Axis.vertical,
        prototypeItem: prototypeItem,
        clipBehavior: clipBehavior,
        addAutomaticKeepAlives: addAutomaticKeepAlives,
        addRepaintBoundaries: addRepaintBoundaries,
        addSemanticIndexes: addSemanticIndexes,
        children: listChildren,
      );
    } else if (itemBuilder != null) {
      final showPlaceholder = showNoMoreData && itemCount != null;
      final listItemCount =
          itemCount == null ? null : itemCount! + (showPlaceholder ? 1 : 0);

      Widget listItemBuilder(BuildContext context, int index) {
        if (showPlaceholder && index == itemCount) {
          return _noMoreDataPlaceholder!;
        }
        return itemBuilder!(context, index);
      }

      if (separatorBuilder != null && itemCount != null) {
        result = ListView.separated(
          padding: padding,
          restorationId: restorationId,
          separatorBuilder: separatorBuilder!,
          keyboardDismissBehavior: keyboardDismissBehavior,
          itemBuilder: listItemBuilder,
          itemCount: listItemCount!,
          shrinkWrap: shrinkWrap,
          physics: physics,
          reverse: reverse,
          controller: controller,
          clipBehavior: clipBehavior,
          scrollDirection: scrollDirection ?? Axis.vertical,
          addAutomaticKeepAlives: addAutomaticKeepAlives,
          addRepaintBoundaries: addRepaintBoundaries,
          addSemanticIndexes: addSemanticIndexes,
        );
      } else {
        result = ListView.builder(
          padding: padding,
          restorationId: restorationId,
          itemBuilder: listItemBuilder,
          itemCount: listItemCount,
          shrinkWrap: shrinkWrap,
          controller: controller,
          physics: physics,
          keyboardDismissBehavior: keyboardDismissBehavior,
          reverse: reverse,
          scrollDirection: scrollDirection ?? Axis.vertical,
          clipBehavior: clipBehavior,
          itemExtent: itemExtent,
          itemExtentBuilder: _itemExtentBuilderWithPlaceholder(
            itemExtentBuilder,
            baseItemCount: itemCount,
            showNoMoreData: showPlaceholder,
          ),
          prototypeItem: prototypeItem,
          addAutomaticKeepAlives: addAutomaticKeepAlives,
          addRepaintBoundaries: addRepaintBoundaries,
          addSemanticIndexes: addSemanticIndexes,
        );
      }
    } else {
      throw '必须传入children或itemBuilder';
    }

    return result;
  }

  Widget? get _noMoreDataPlaceholder {
    return loadMoreConfig?.effectiveNoMoreDataPlaceholder;
  }

  int? get _itemCount => children?.length ?? itemCount;

  ItemExtentBuilder? _itemExtentBuilderWithPlaceholder(
    ItemExtentBuilder? builder, {
    required int? baseItemCount,
    required bool showNoMoreData,
  }) {
    if (builder == null || baseItemCount == null || !showNoMoreData) {
      return builder;
    }
    return (index, dimensions) {
      if (index >= baseItemCount) return 48;
      return builder(index, dimensions);
    };
  }
}
