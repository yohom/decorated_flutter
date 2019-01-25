import 'package:flutter/material.dart';

typedef void PressedCallback(BuildContext context);

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
    this.textBaseline,
    this.onPressed,
    this.onLongPressed,
    this.behavior = HitTestBehavior.opaque,
    this.itemSpacing = 0,
    this.visible = true,
    this.expanded = false,
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
  final TextBaseline textBaseline;

  //endregion
  //region GestureDetector
  final PressedCallback onPressed;
  final PressedCallback onLongPressed;
  final HitTestBehavior behavior;

  //endregion
  final double itemSpacing;
  final bool visible;
  final bool expanded;
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
      textBaseline: textBaseline,
      onPressed: onPressed,
      onLongPressed: onLongPressed,
      behavior: behavior,
      itemSpacing: itemSpacing,
      visible: visible,
      expanded: expanded,
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
    this.textBaseline,
    this.onPressed,
    this.onLongPressed,
    this.behavior = HitTestBehavior.opaque,
    this.itemSpacing = 0,
    this.visible = true,
    this.expanded = false,
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
  final TextBaseline textBaseline;

  //endregion
  //region GestureDetector
  final PressedCallback onPressed;
  final PressedCallback onLongPressed;
  final HitTestBehavior behavior;

  //endregion
  final double itemSpacing;
  final bool visible;
  final bool expanded;
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
      textBaseline: textBaseline,
      onPressed: onPressed,
      onLongPressed: onLongPressed,
      behavior: behavior,
      itemSpacing: itemSpacing,
      visible: visible,
      expanded: expanded,
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
    this.textBaseline,
    this.onPressed,
    this.onLongPressed,
    this.behavior = HitTestBehavior.opaque,
    this.itemSpacing = 0,
    this.visible = true,
    this.expanded = false,
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
  final TextBaseline textBaseline;

  //endregion
  //region GestureDetector
  final PressedCallback onPressed;
  final PressedCallback onLongPressed;
  final HitTestBehavior behavior;

  //endregion
  final double itemSpacing;
  final bool visible;
  final bool expanded;
  final List<Widget> children;

  @override
  Widget build(BuildContext context) {
    Widget result = Flex(
      direction: direction,
      mainAxisAlignment: mainAxisAlignment,
      mainAxisSize: mainAxisSize,
      crossAxisAlignment: crossAxisAlignment,
      textBaseline: textBaseline,
      children: itemSpacing != 0
          ? addItemSpacing(children: children, itemSpacing: itemSpacing)
          : children,
    );

    if (padding != null ||
        margin != null ||
        width != null ||
        height != null ||
        color != null ||
        decoration != null ||
        foregroundDecoration != null ||
        constraints != null ||
        transform != null ||
        alignment != null) {
      result = Container(
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
        child: result,
      );
    }

    if (behavior != null || onPressed != null || onLongPressed != null) {
      result = GestureDetector(
        behavior: behavior,
        onTap: () => onPressed(context),
        onLongPress: () => onLongPressed(context),
        child: result,
      );
    }

    if (expanded) {
      result = Expanded(child: result);
    }
    return Visibility(visible: visible, child: result);
  }

  List<Widget> addItemSpacing({
    @required List<Widget> children,
    @required double itemSpacing,
  }) {
    assert(children != null);

    // 确认要往哪几个index(以最终的插入后的List为参考系)插空间
    int currentLength = children.length;
    if (currentLength > 1) {
      final indexes = <int>[];
      // `currentLength + (currentLength - 1)`是插入后的长度
      // 这里的循环是在纸上画过得出的结论
      for (int i = 1; i < currentLength + (currentLength - 1); i += 2) {
        indexes.add(i);
      }

      if (direction == Axis.horizontal) {
        indexes.forEach((index) {
          children.insert(index, SizedBox(width: itemSpacing));
        });
      } else if (direction == Axis.vertical) {
        indexes.forEach((index) {
          children.insert(index, SizedBox(height: itemSpacing));
        });
      }
    }

    return children;
  }
}
