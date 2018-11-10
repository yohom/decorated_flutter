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
        child: Row(
          mainAxisAlignment: mainAxisAlignment,
          mainAxisSize: mainAxisSize,
          crossAxisAlignment: crossAxisAlignment,
          children: children,
        ),
      ),
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
        child: Column(
          mainAxisAlignment: mainAxisAlignment,
          mainAxisSize: mainAxisSize,
          crossAxisAlignment: crossAxisAlignment,
          children: children,
        ),
      ),
    );
  }
}
