import 'package:flutter/material.dart';

class DecoratedList extends StatelessWidget {
  const DecoratedList.box({
    Key? key,
    this.padding,
    this.shrinkWrap = false,
    this.itemBuilder,
    this.itemCount,
    this.children,
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
    this.addAutomaticKeepAlives = true,
    this.addRepaintBoundaries = true,
    this.addSemanticIndexes = true,
    this.itemExtent,
    this.prototypeItem,
  })  : _sliver = true,
        shrinkWrap = false,
        super(key: key);

  final bool _sliver;
  final EdgeInsets? padding;
  final bool shrinkWrap;
  final IndexedWidgetBuilder? itemBuilder;
  final int? itemCount;
  final List<Widget>? children;
  final bool addAutomaticKeepAlives;
  final bool addRepaintBoundaries;
  final bool addSemanticIndexes;
  final double? itemExtent;
  final Widget? prototypeItem;

  @override
  Widget build(BuildContext context) {
    return _sliver ? _sliverList() : _boxList();
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
