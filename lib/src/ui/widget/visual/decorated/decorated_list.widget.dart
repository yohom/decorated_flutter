import 'package:flutter/material.dart';

class DecoratedList extends StatelessWidget {
  const DecoratedList.box({
    Key? key,
    this.padding,
    this.shrinkWrap = false,
    required this.itemBuilder,
    this.itemCount,
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
    required this.itemBuilder,
    this.itemCount,
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
  final IndexedWidgetBuilder itemBuilder;
  final int? itemCount;
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
    final delegate = SliverChildBuilderDelegate(
      itemBuilder,
      childCount: itemCount,
      addAutomaticKeepAlives: addAutomaticKeepAlives,
      addRepaintBoundaries: addRepaintBoundaries,
      addSemanticIndexes: addSemanticIndexes,
    );

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
    Widget result = ListView.builder(
      padding: padding,
      itemBuilder: itemBuilder,
      itemCount: itemCount,
      shrinkWrap: shrinkWrap,
      itemExtent: itemExtent,
      prototypeItem: prototypeItem,
      addAutomaticKeepAlives: addAutomaticKeepAlives,
      addRepaintBoundaries: addRepaintBoundaries,
      addSemanticIndexes: addSemanticIndexes,
    );

    return result;
  }
}
