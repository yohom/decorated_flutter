import 'package:diffutil_dart/diffutil.dart';
import 'package:flutter/material.dart';
import 'package:flutter/rendering.dart' show ItemExtentBuilder;

import 'decorated_scrollable.widget.dart';
import 'load_more.widget.dart';
import 'scrollable_top_divider.widget.dart';

class DecoratedList<T> extends StatelessWidget {
  const DecoratedList.box({
    super.key,
    this.padding,
    this.restorationId,
    this.shrinkWrap = false,
    this.itemBuilder,
    this.itemCount,
    this.children,
    this.dataSource,
    this.dataSourceItemBuilder,
    this.dataSourceKey,
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
        assert((dataSource == null) == (dataSourceItemBuilder == null)),
        assert(dataSource == null || children == null),
        assert(dataSource == null || itemBuilder == null),
        assert(
          dataSource == null ||
              itemCount == null ||
              itemCount == dataSource.length,
        ),
        assert(
          dataSource == null ||
              (itemExtent == null &&
                  itemExtentBuilder == null &&
                  prototypeItem == null),
          'Animated data sources cannot be combined with item extents.',
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
    this.dataSource,
    this.dataSourceItemBuilder,
    this.dataSourceKey,
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
        assert((dataSource == null) == (dataSourceItemBuilder == null)),
        assert(
          dataSource == null || itemCount == dataSource.length,
        ),
        assert(dataSource == null || itemBuilder == null),
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
    this.dataSource,
    this.dataSourceItemBuilder,
    this.dataSourceKey,
    this.separatorBuilder,
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
        assert((dataSource == null) == (dataSourceItemBuilder == null)),
        assert(dataSource == null || children == null),
        assert(dataSource == null || itemBuilder == null),
        assert(
          dataSource == null ||
              itemCount == null ||
              itemCount == dataSource.length,
        ),
        assert(
          dataSource == null ||
              (itemExtent == null &&
                  itemExtentBuilder == null &&
                  prototypeItem == null),
          'Animated data sources cannot be combined with item extents.',
        ),
        assert(
          separatorBuilder == null ||
              (itemExtent == null &&
                  itemExtentBuilder == null &&
                  prototypeItem == null),
          'separatorBuilder cannot be used with itemExtent, itemExtentBuilder or prototypeItem.',
        ),
        _sliver = true,
        shrinkWrap = false,
        scrollDirection = null,
        controller = null,
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
  final List<T>? dataSource;

  /// Builds an item from the animated data source and its current index.
  ///
  /// When provided with [dataSource], additions and removals are animated.
  /// Items are matched by [dataSourceKey], or by `==` when it is omitted.
  /// Reordering is animated as a removal followed by an insertion.
  final Widget Function(BuildContext context, T item, int index)?
      dataSourceItemBuilder;

  /// Returns a stable identity for an item when model equality is not stable.
  final Object? Function(T item)? dataSourceKey;
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

    Widget buildItem(BuildContext context, int index) {
      if (children != null) return children![index];
      if (itemBuilder != null) return itemBuilder!(context, index);
      throw '必须传入children或itemBuilder';
    }

    Widget result;
    if (dataSource != null) {
      result = _ImplicitAnimatedDataList<T>(
        dataSource: dataSource!,
        itemBuilder: dataSourceItemBuilder!,
        itemKey: dataSourceKey,
        separatorBuilder: separatorBuilder,
        sliver: true,
      );
    } else if (separatorBuilder != null) {
      result = SliverList.separated(
        itemBuilder: buildItem,
        separatorBuilder: separatorBuilder!,
        itemCount: baseItemCount,
        addAutomaticKeepAlives: addAutomaticKeepAlives,
        addRepaintBoundaries: addRepaintBoundaries,
        addSemanticIndexes: addSemanticIndexes,
      );
    } else {
      final delegate = SliverChildBuilderDelegate(
        buildItem,
        childCount: baseItemCount,
        addAutomaticKeepAlives: addAutomaticKeepAlives,
        addRepaintBoundaries: addRepaintBoundaries,
        addSemanticIndexes: addSemanticIndexes,
      );

      result = prototypeItem != null
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
    }

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

    if (dataSource != null) {
      result = _ImplicitAnimatedDataList<T>(
        dataSource: dataSource!,
        itemBuilder: dataSourceItemBuilder!,
        itemKey: dataSourceKey,
        separatorBuilder: separatorBuilder,
        sliver: false,
        padding: padding,
        controller: controller,
        shrinkWrap: shrinkWrap,
        physics: physics,
        reverse: reverse,
        scrollDirection: scrollDirection ?? Axis.vertical,
        keyboardDismissBehavior: keyboardDismissBehavior,
        restorationId: restorationId,
        clipBehavior: clipBehavior,
        showPlaceholder: showNoMoreData,
        placeholder: _noMoreDataPlaceholder,
      );
    } else if (children != null) {
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

  int? get _itemCount => dataSource?.length ?? children?.length ?? itemCount;

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

class _AnimatedDataEntry<T> {
  const _AnimatedDataEntry({
    required this.identity,
    this.item,
    this.index = -1,
    this.hasSeparator = false,
    this.placeholder,
  });

  final Object? identity;
  final T? item;
  final int index;
  final bool hasSeparator;
  final Widget? placeholder;

  bool get isPlaceholder => placeholder != null;
}

class _AnimatedPlaceholderIdentity {
  const _AnimatedPlaceholderIdentity();
}

class _ImplicitAnimatedDataList<T> extends StatefulWidget {
  const _ImplicitAnimatedDataList({
    required this.dataSource,
    required this.itemBuilder,
    required this.itemKey,
    required this.sliver,
    this.separatorBuilder,
    this.padding,
    this.controller,
    this.shrinkWrap = false,
    this.physics,
    this.reverse = false,
    this.scrollDirection = Axis.vertical,
    this.keyboardDismissBehavior = ScrollViewKeyboardDismissBehavior.onDrag,
    this.restorationId,
    this.clipBehavior = Clip.hardEdge,
    this.showPlaceholder = false,
    this.placeholder,
  });

  final List<T> dataSource;
  final Widget Function(BuildContext context, T item, int index) itemBuilder;
  final Object? Function(T item)? itemKey;
  final IndexedWidgetBuilder? separatorBuilder;
  final bool sliver;
  final EdgeInsets? padding;
  final ScrollController? controller;
  final bool shrinkWrap;
  final ScrollPhysics? physics;
  final bool reverse;
  final Axis scrollDirection;
  final ScrollViewKeyboardDismissBehavior keyboardDismissBehavior;
  final String? restorationId;
  final Clip clipBehavior;
  final bool showPlaceholder;
  final Widget? placeholder;

  @override
  State<_ImplicitAnimatedDataList<T>> createState() =>
      _ImplicitAnimatedDataListState<T>();
}

class _ImplicitAnimatedDataListState<T>
    extends State<_ImplicitAnimatedDataList<T>> {
  static const _duration = Duration(milliseconds: 300);
  static const _placeholderIdentity = _AnimatedPlaceholderIdentity();

  final _sliverListKey = GlobalKey<SliverAnimatedListState>();
  late List<_AnimatedDataEntry<T>> _entries;

  @override
  void initState() {
    super.initState();
    _entries = _createEntries();
  }

  @override
  void didUpdateWidget(covariant _ImplicitAnimatedDataList<T> oldWidget) {
    super.didUpdateWidget(oldWidget);
    final nextEntries = _createEntries();
    final listState = _sliverListKey.currentState;
    if (listState == null) {
      _entries = nextEntries;
      return;
    }

    final updates = calculateListDiff<_AnimatedDataEntry<T>>(
      _entries,
      nextEntries,
      detectMoves: false,
      equalityChecker: (a, b) => a.identity == b.identity,
    ).getUpdatesWithData();
    for (final update in updates) {
      update.when<void>(
        insert: _insertItem,
        remove: _removeItem,
        change: (index, _, newEntry) => _entries[index] = newEntry,
        move: (_, __, ___) {},
      );
    }
    _entries = nextEntries;
  }

  List<_AnimatedDataEntry<T>> _createEntries() {
    final count = widget.dataSource.length;
    final hasPlaceholder = widget.showPlaceholder && widget.placeholder != null;
    final totalCount = count + (hasPlaceholder ? 1 : 0);
    return [
      for (var index = 0; index < count; index++)
        _AnimatedDataEntry<T>(
          identity: widget.itemKey == null
              ? widget.dataSource[index]
              : widget.itemKey!(widget.dataSource[index]),
          item: widget.dataSource[index],
          index: index,
          hasSeparator:
              widget.separatorBuilder != null && index < totalCount - 1,
        ),
      if (hasPlaceholder)
        _AnimatedDataEntry<T>(
          identity: _placeholderIdentity,
          placeholder: widget.placeholder,
        ),
    ];
  }

  void _removeItem(int index, _AnimatedDataEntry<T> entry) {
    Widget builder(BuildContext context, Animation<double> animation) =>
        _buildEntry(context, entry, animation);

    _sliverListKey.currentState!.removeItem(
      index,
      builder,
      duration: _duration,
    );
    _entries.removeAt(index);
  }

  void _insertItem(int index, _AnimatedDataEntry<T> entry) {
    _sliverListKey.currentState!.insertItem(index, duration: _duration);
    _entries.insert(index, entry);
  }

  Widget _buildEntry(
    BuildContext context,
    _AnimatedDataEntry<T> entry,
    Animation<double> animation,
  ) {
    final axis = widget.sliver ? _sliverAxis(context) : widget.scrollDirection;
    Widget child = entry.isPlaceholder
        ? entry.placeholder!
        : widget.itemBuilder(context, entry.item as T, entry.index);
    if (entry.hasSeparator) {
      final separator = widget.separatorBuilder!(context, entry.index);
      child = axis == Axis.horizontal
          ? Row(mainAxisSize: MainAxisSize.min, children: [child, separator])
          : Column(
              crossAxisAlignment: CrossAxisAlignment.stretch,
              mainAxisSize: MainAxisSize.min,
              children: [child, separator],
            );
    }
    return FadeTransition(
      opacity: animation,
      child: SizeTransition(
        axis: axis,
        axisAlignment: -1,
        sizeFactor: animation,
        child: child,
      ),
    );
  }

  Axis _sliverAxis(BuildContext context) {
    final direction = Scrollable.maybeOf(context)?.position.axisDirection;
    return direction == AxisDirection.left || direction == AxisDirection.right
        ? Axis.horizontal
        : Axis.vertical;
  }

  @override
  Widget build(BuildContext context) {
    Widget list = SliverAnimatedList(
      key: _sliverListKey,
      initialItemCount: _entries.length,
      itemBuilder: (context, index, animation) =>
          _buildEntry(context, _entries[index], animation),
    );
    if (widget.padding != null) {
      list = SliverPadding(padding: widget.padding!, sliver: list);
    }
    if (widget.sliver) return list;
    return CustomScrollView(
      controller: widget.controller,
      shrinkWrap: widget.shrinkWrap,
      physics: widget.physics,
      reverse: widget.reverse,
      scrollDirection: widget.scrollDirection,
      keyboardDismissBehavior: widget.keyboardDismissBehavior,
      restorationId: widget.restorationId,
      clipBehavior: widget.clipBehavior,
      slivers: [list],
    );
  }
}
