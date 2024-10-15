import 'package:flutter/material.dart';

final class TopDividerConfig {
  TopDividerConfig({
    this.show = true,
    this.color = Colors.black12,
    this.thickness = 1,
    this.duration = const Duration(milliseconds: 320),
  });

  final bool show;
  final Color color;
  final double thickness;
  final Duration duration;
}

class DecoratedList extends StatefulWidget {
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
    this.clipBehavior = Clip.none,
    this.reverse = false,
    this.topDivider,
  })  : _sliver = false,
        separatorBuilder = null;

  const DecoratedList.boxSeparated({
    super.key,
    this.padding,
    this.restorationId,
    this.shrinkWrap = false,
    this.itemBuilder,
    required this.itemCount,
    this.children,
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
    this.clipBehavior = Clip.none,
    this.topDivider,
  })  : assert(itemCount != null),
        assert(separatorBuilder != null),
        _sliver = false,
        itemExtent = null,
        prototypeItem = null;

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
        topDivider = null;

  final bool _sliver;
  final String? restorationId;
  final EdgeInsets? padding;
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
  final TopDividerConfig? topDivider;

  @override
  State<DecoratedList> createState() => _DecoratedListState();
}

class _DecoratedListState extends State<DecoratedList> {
  bool _showTopDivider = false;

  @override
  Widget build(BuildContext context) {
    Widget result = widget._sliver ? _sliverList() : _boxList();

    if (widget.width != null || widget.height != null) {
      result = SizedBox(
        width: widget.width,
        height: widget.height,
        child: result,
      );
    }

    if (widget.decoration != null) {
      result = Container(
        clipBehavior: widget.clipBehavior,
        decoration: widget.decoration,
        child: result,
      );
    }

    if (widget.topDivider case TopDividerConfig config) {
      result = NotificationListener<ScrollUpdateNotification>(
        onNotification: (notification) {
          if (notification.metrics.pixels > 0 && !_showTopDivider) {
            setState(() {
              _showTopDivider = true;
            });
          } else if (notification.metrics.pixels <= 0) {
            setState(() {
              _showTopDivider = false;
            });
          }
          return false;
        },
        child: AnimatedContainer(
          duration: config.duration,
          decoration: BoxDecoration(
            border: Border(
              top: BorderSide(
                color: _showTopDivider ? config.color : Colors.transparent,
                width: config.thickness,
              ),
            ),
          ),
          child: result,
        ),
      );
    }

    if (widget.expanded == true) {
      result = Expanded(child: result);
    }

    return result;
  }

  Widget _sliverList() {
    SliverChildDelegate delegate;

    if (widget.children != null) {
      delegate = SliverChildListDelegate(
        widget.children!,
        addAutomaticKeepAlives: widget.addAutomaticKeepAlives,
        addRepaintBoundaries: widget.addRepaintBoundaries,
        addSemanticIndexes: widget.addSemanticIndexes,
      );
    } else if (widget.itemBuilder != null) {
      delegate = SliverChildBuilderDelegate(
        widget.itemBuilder!,
        childCount: widget.itemCount,
        addAutomaticKeepAlives: widget.addAutomaticKeepAlives,
        addRepaintBoundaries: widget.addRepaintBoundaries,
        addSemanticIndexes: widget.addSemanticIndexes,
      );
    } else {
      throw '必须传入children或itemBuilder';
    }

    Widget result = widget.prototypeItem != null
        ? SliverPrototypeExtentList(
            delegate: delegate,
            prototypeItem: widget.prototypeItem!,
          )
        : widget.itemExtent != null
            ? SliverFixedExtentList(
                delegate: delegate, itemExtent: widget.itemExtent!)
            : SliverList(delegate: delegate);

    if (widget.padding != null) {
      result = SliverPadding(padding: widget.padding!, sliver: result);
    }

    return result;
  }

  Widget _boxList() {
    Widget result;
    if (widget.children != null) {
      result = ListView(
        padding: widget.padding,
        keyboardDismissBehavior: widget.keyboardDismissBehavior,
        restorationId: widget.restorationId,
        controller: widget.controller,
        shrinkWrap: widget.shrinkWrap,
        itemExtent: widget.itemExtent,
        physics: widget.physics,
        reverse: widget.reverse,
        scrollDirection: widget.scrollDirection ?? Axis.vertical,
        prototypeItem: widget.prototypeItem,
        addAutomaticKeepAlives: widget.addAutomaticKeepAlives,
        addRepaintBoundaries: widget.addRepaintBoundaries,
        addSemanticIndexes: widget.addSemanticIndexes,
        children: widget.children!,
      );
    } else if (widget.itemBuilder != null) {
      if (widget.separatorBuilder != null && widget.itemCount != null) {
        result = ListView.separated(
          padding: widget.padding,
          restorationId: widget.restorationId,
          separatorBuilder: widget.separatorBuilder!,
          keyboardDismissBehavior: widget.keyboardDismissBehavior,
          itemBuilder: widget.itemBuilder!,
          itemCount: widget.itemCount!,
          shrinkWrap: widget.shrinkWrap,
          physics: widget.physics,
          reverse: widget.reverse,
          controller: widget.controller,
          scrollDirection: widget.scrollDirection ?? Axis.vertical,
          addAutomaticKeepAlives: widget.addAutomaticKeepAlives,
          addRepaintBoundaries: widget.addRepaintBoundaries,
          addSemanticIndexes: widget.addSemanticIndexes,
        );
      } else {
        result = ListView.builder(
          padding: widget.padding,
          restorationId: widget.restorationId,
          itemBuilder: widget.itemBuilder!,
          itemCount: widget.itemCount,
          shrinkWrap: widget.shrinkWrap,
          controller: widget.controller,
          physics: widget.physics,
          keyboardDismissBehavior: widget.keyboardDismissBehavior,
          reverse: widget.reverse,
          scrollDirection: widget.scrollDirection ?? Axis.vertical,
          itemExtent: widget.itemExtent,
          prototypeItem: widget.prototypeItem,
          addAutomaticKeepAlives: widget.addAutomaticKeepAlives,
          addRepaintBoundaries: widget.addRepaintBoundaries,
          addSemanticIndexes: widget.addSemanticIndexes,
        );
      }
    } else {
      throw '必须传入children或itemBuilder';
    }

    return result;
  }
}
