import 'package:flutter/material.dart';

class DecoratedList extends StatelessWidget {
  const DecoratedList.box({
    Key? key,
    this.padding,
    this.shrinkWrap = false,
    this.itemBuilder,
    this.itemCount,
    this.children,
    this.scrollDirection,
    this.width,
    this.height,
    this.addAutomaticKeepAlives = true,
    this.addRepaintBoundaries = true,
    this.addSemanticIndexes = true,
    this.itemExtent,
    this.prototypeItem,
  })  : _sliver = false,
        super(key: key);

  const DecoratedList.sliver({
    Key? key,
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
        super(key: key);

  final bool _sliver;
  final EdgeInsets? padding;
  final bool shrinkWrap;
  final IndexedWidgetBuilder? itemBuilder;
  final int? itemCount;
  final Axis? scrollDirection;
  final List<Widget>? children;
  final double? width, height;
  final bool addAutomaticKeepAlives, addRepaintBoundaries, addSemanticIndexes;
  final double? itemExtent;
  final Widget? prototypeItem;

  @override
  Widget build(BuildContext context) {
    Widget result = _sliver ? _sliverList() : _boxList();

    if (width != null || height != null) {
      result = SizedBox(width: width, height: height, child: result);
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
        children: children!,
        shrinkWrap: shrinkWrap,
        itemExtent: itemExtent,
        scrollDirection: scrollDirection ?? Axis.vertical,
        prototypeItem: prototypeItem,
        addAutomaticKeepAlives: addAutomaticKeepAlives,
        addRepaintBoundaries: addRepaintBoundaries,
        addSemanticIndexes: addSemanticIndexes,
      );
    } else if (itemBuilder != null) {
      result = ListView.builder(
        padding: padding,
        itemBuilder: itemBuilder!,
        itemCount: itemCount,
        shrinkWrap: shrinkWrap,
        scrollDirection: scrollDirection ?? Axis.vertical,
        itemExtent: itemExtent,
        prototypeItem: prototypeItem,
        addAutomaticKeepAlives: addAutomaticKeepAlives,
        addRepaintBoundaries: addRepaintBoundaries,
        addSemanticIndexes: addSemanticIndexes,
      );
    } else {
      throw '必须传入children或itemBuilder';
    }

    return result;
  }
}
