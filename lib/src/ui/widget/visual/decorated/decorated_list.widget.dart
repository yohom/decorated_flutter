import 'package:flutter/material.dart';

import 'decorated_scrollable.widget.dart';
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
  })  : _sliver = false,
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
  })  : assert(itemCount != null),
        assert(separatorBuilder != null),
        _sliver = false,
        itemExtent = null,
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
    this.prototypeItem,
  })  : _sliver = true,
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
        margin = null;

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

  @override
  Widget build(BuildContext context) {
    Widget result = _sliver ? _sliverList() : _boxList();

    if (width != null || height != null) {
      result = SizedBox(
        width: width,
        height: height,
        child: result,
      );
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
    SliverChildDelegate delegate;

    if (children != null) {
      delegate = SliverChildListDelegate(
        children!,
        addAutomaticKeepAlives: addAutomaticKeepAlives,
        addRepaintBoundaries: addRepaintBoundaries,
        addSemanticIndexes: addSemanticIndexes,
      );
    } else if (itemBuilder != null) {
      delegate = SliverChildBuilderDelegate(
        itemBuilder!,
        childCount: itemCount,
        addAutomaticKeepAlives: addAutomaticKeepAlives,
        addRepaintBoundaries: addRepaintBoundaries,
        addSemanticIndexes: addSemanticIndexes,
      );
    } else {
      throw '必须传入children或itemBuilder';
    }

    Widget result = prototypeItem != null
        ? SliverPrototypeExtentList(
            delegate: delegate,
            prototypeItem: prototypeItem!,
          )
        : itemExtent != null
            ? SliverFixedExtentList(delegate: delegate, itemExtent: itemExtent!)
            : SliverList(delegate: delegate);

    if (padding != null) {
      result = SliverPadding(padding: padding!, sliver: result);
    }

    return result;
  }

  Widget _boxList() {
    Widget result;
    if (children != null) {
      result = ListView(
        padding: padding,
        keyboardDismissBehavior: keyboardDismissBehavior,
        restorationId: restorationId,
        controller: controller,
        shrinkWrap: shrinkWrap,
        itemExtent: itemExtent,
        physics: physics,
        reverse: reverse,
        scrollDirection: scrollDirection ?? Axis.vertical,
        prototypeItem: prototypeItem,
        clipBehavior: clipBehavior,
        addAutomaticKeepAlives: addAutomaticKeepAlives,
        addRepaintBoundaries: addRepaintBoundaries,
        addSemanticIndexes: addSemanticIndexes,
        children: children!,
      );
    } else if (itemBuilder != null) {
      if (separatorBuilder != null && itemCount != null) {
        result = ListView.separated(
          padding: padding,
          restorationId: restorationId,
          separatorBuilder: separatorBuilder!,
          keyboardDismissBehavior: keyboardDismissBehavior,
          itemBuilder: itemBuilder!,
          itemCount: itemCount!,
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
          itemBuilder: itemBuilder!,
          itemCount: itemCount,
          shrinkWrap: shrinkWrap,
          controller: controller,
          physics: physics,
          keyboardDismissBehavior: keyboardDismissBehavior,
          reverse: reverse,
          scrollDirection: scrollDirection ?? Axis.vertical,
          clipBehavior: clipBehavior,
          itemExtent: itemExtent,
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
}
