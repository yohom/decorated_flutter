import 'package:flutter/material.dart';

class DecoratedRow extends StatelessWidget {
  const DecoratedRow({
    Key key,
    this.padding,
    this.margin,
    this.color,
    this.decoration,
    this.foregroundDecoration,
    this.constraints,
    this.transform,
    this.width,
    this.height,
    this.alignment,
    this.mainAxisAlignment = MainAxisAlignment.start,
    this.mainAxisSize = MainAxisSize.max,
    this.crossAxisAlignment = CrossAxisAlignment.center,
    this.onTap,
    this.onLongPress,
    this.behavior = HitTestBehavior.opaque,
    this.itemMargin = 0,
    this.children,
  }) : super(key: key);

  //region Container
  final EdgeInsets padding;
  final EdgeInsets margin;
  final Color color;
  final Decoration decoration;
  final Decoration foregroundDecoration;
  final BoxConstraints constraints;
  final Matrix4 transform;
  final double width;
  final double height;

  //endregion
  //region Row
  final AlignmentGeometry alignment;
  final MainAxisAlignment mainAxisAlignment;
  final MainAxisSize mainAxisSize;
  final CrossAxisAlignment crossAxisAlignment;

  //endregion
  //region GestureDetector
  final VoidCallback onTap;
  final VoidCallback onLongPress;
  final HitTestBehavior behavior;

  //endregion
  final double itemMargin;
  final List<Widget> children;

  @override
  Widget build(BuildContext context) {
    return DecoratedFlex(
      direction: Axis.horizontal,
      padding: padding,
      margin: margin,
      color: color,
      decoration: decoration,
      foregroundDecoration: foregroundDecoration,
      constraints: constraints,
      transform: transform,
      width: width,
      height: height,
      alignment: alignment,
      mainAxisAlignment: mainAxisAlignment,
      mainAxisSize: mainAxisSize,
      crossAxisAlignment: crossAxisAlignment,
      onTap: onTap,
      onLongPress: onLongPress,
      behavior: behavior,
      itemMargin: itemMargin,
      children: children,
    );
  }
}

class DecoratedColumn extends StatelessWidget {
  const DecoratedColumn({
    Key key,
    this.padding,
    this.margin,
    this.color,
    this.decoration,
    this.foregroundDecoration,
    this.constraints,
    this.transform,
    this.width,
    this.height,
    this.alignment,
    this.mainAxisAlignment = MainAxisAlignment.start,
    this.mainAxisSize = MainAxisSize.max,
    this.crossAxisAlignment = CrossAxisAlignment.center,
    this.onTap,
    this.onLongPress,
    this.behavior = HitTestBehavior.opaque,
    this.itemMargin = 0,
    this.children,
  }) : super(key: key);

  //region Container
  final EdgeInsets padding;
  final EdgeInsets margin;
  final Color color;
  final Decoration decoration;
  final Decoration foregroundDecoration;
  final BoxConstraints constraints;
  final Matrix4 transform;
  final double width;
  final double height;

  //endregion
  //region Row
  final AlignmentGeometry alignment;
  final MainAxisAlignment mainAxisAlignment;
  final MainAxisSize mainAxisSize;
  final CrossAxisAlignment crossAxisAlignment;

  //endregion
  //region GestureDetector
  final VoidCallback onTap;
  final VoidCallback onLongPress;
  final HitTestBehavior behavior;

  //endregion
  final double itemMargin;
  final List<Widget> children;

  @override
  Widget build(BuildContext context) {
    return DecoratedFlex(
      direction: Axis.vertical,
      padding: padding,
      margin: margin,
      color: color,
      decoration: decoration,
      foregroundDecoration: foregroundDecoration,
      constraints: constraints,
      transform: transform,
      width: width,
      height: height,
      alignment: alignment,
      mainAxisAlignment: mainAxisAlignment,
      mainAxisSize: mainAxisSize,
      crossAxisAlignment: crossAxisAlignment,
      onTap: onTap,
      onLongPress: onLongPress,
      behavior: behavior,
      itemMargin: itemMargin,
      children: children,
    );
  }
}

class DecoratedFlex extends StatelessWidget {
  DecoratedFlex({
    Key key,
    this.padding,
    this.margin,
    this.color,
    this.decoration,
    this.foregroundDecoration,
    this.constraints,
    this.transform,
    this.width,
    this.height,
    @required this.direction,
    this.alignment,
    this.mainAxisAlignment = MainAxisAlignment.start,
    this.mainAxisSize = MainAxisSize.max,
    this.crossAxisAlignment = CrossAxisAlignment.center,
    this.onTap,
    this.onLongPress,
    this.behavior = HitTestBehavior.opaque,
    this.itemMargin = 0,
    this.children,
  }) : super(key: key);

  //region Container
  final EdgeInsets padding;
  final EdgeInsets margin;
  final Color color;
  final Decoration decoration;
  final Decoration foregroundDecoration;
  final BoxConstraints constraints;
  final Matrix4 transform;
  final double width;
  final double height;

  //endregion
  //region Flex
  final Axis direction;
  final AlignmentGeometry alignment;
  final MainAxisAlignment mainAxisAlignment;
  final MainAxisSize mainAxisSize;
  final CrossAxisAlignment crossAxisAlignment;

  //endregion
  //region GestureDetector
  final VoidCallback onTap;
  final VoidCallback onLongPress;
  final HitTestBehavior behavior;

  //endregion
  final double itemMargin;
  final List<Widget> children;

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      behavior: behavior,
      onTap: onTap,
      onLongPress: onLongPress,
      child: Container(
        padding: padding,
        margin: margin,
        width: width,
        height: height,
        color: color,
        decoration: decoration,
        foregroundDecoration: foregroundDecoration,
        constraints: constraints,
        transform: transform,
        alignment: alignment,
        child: Flex(
          direction: direction,
          mainAxisAlignment: mainAxisAlignment,
          mainAxisSize: mainAxisSize,
          crossAxisAlignment: crossAxisAlignment,
          children: itemMargin != 0
              ? addItemMargin(children: children, itemMargin: itemMargin)
                  .toList()
              : children,
        ),
      ),
    );
  }

  Iterable<Widget> addItemMargin({
    @required Iterable<Widget> children,
    @required double itemMargin,
  }) sync* {
    assert(children != null);

    final Iterator<Widget> iterator = children.iterator;
    final bool isNotEmpty = iterator.moveNext();

    Widget tile = iterator.current;
    while (iterator.moveNext()) {
      yield Container(
        padding: EdgeInsets.only(bottom: itemMargin),
        child: tile,
      );
      tile = iterator.current;
    }
    if (isNotEmpty) yield tile;
  }
}
