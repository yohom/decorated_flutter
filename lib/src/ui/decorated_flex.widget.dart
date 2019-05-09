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
    this.crossExpanded = false,
    this.forceItemSameExtent = false,
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
  /// item间距
  final double itemSpacing;

  /// 是否可见
  final bool visible;

  /// 垂直方向上Expand
  final bool crossExpanded;

  /// 强制子widget拥有相同的宽度, 会获取到屏幕宽度然后除以item个数来计算
  final bool forceItemSameExtent;
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
      crossExpanded: crossExpanded,
      forceItemSameExtent: forceItemSameExtent,
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
    this.crossExpanded = false,
    this.scrollable = false,
    this.forceItemSameExtent = false,
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
  final bool crossExpanded;
  final bool scrollable;

  /// 强制子widget拥有相同的高度, 会获取到屏幕高度然后除以item个数来计算
  final bool forceItemSameExtent;
  final List<Widget> children;

  @override
  Widget build(BuildContext context) {
    Widget result = DecoratedFlex(
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
      crossExpanded: crossExpanded,
      forceItemSameExtent: forceItemSameExtent,
      children: children,
    );

    if (scrollable) {
      result = ListView(children: <Widget>[result], shrinkWrap: true);
    }

    return result;
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
    this.crossExpanded = false,
    this.forceItemSameExtent = false,
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
  final bool crossExpanded;
  final bool forceItemSameExtent;
  final List<Widget> children;

  @override
  Widget build(BuildContext context) {
    List<Widget> _children = children;

    if (forceItemSameExtent) {
      _children = children.map((it) {
        if (direction == Axis.horizontal) {
          return SizedBox(
            width: MediaQuery.of(context).size.width / children.length,
            child: it,
          );
        }
        if (direction == Axis.vertical) {
          return SizedBox(
            width: MediaQuery.of(context).size.height / children.length,
            child: it,
          );
        }
      }).toList();
    }

    Widget result = Flex(
      direction: direction,
      mainAxisAlignment: mainAxisAlignment,
      mainAxisSize: mainAxisSize,
      crossAxisAlignment: crossAxisAlignment,
      textBaseline: textBaseline,
      children: itemSpacing != 0
          ? addItemSpacing(children: _children, itemSpacing: itemSpacing)
          : _children,
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
        behavior: behavior == null ?? result != null
            ? HitTestBehavior.deferToChild
            : HitTestBehavior.translucent,
        onTap: onPressed != null ? () => onPressed(context) : null,
        onLongPress:
            onLongPressed != null ? () => onLongPressed(context) : null,
        child: result,
      );
    }

    if (crossExpanded) {
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
