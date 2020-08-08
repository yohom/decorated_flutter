import 'package:decorated_flutter/decorated_flutter.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';

typedef void PressedCallback(BuildContext context);

class DecoratedRow extends DecoratedFlex {
  const DecoratedRow({
    Key key,
    EdgeInsets padding,
    EdgeInsets margin,
    Color color,
    Decoration decoration,
    Decoration foregroundDecoration,
    BoxConstraints constraints,
    Matrix4 transform,
    double width,
    double height,
    AlignmentGeometry alignment,
    MainAxisAlignment mainAxisAlignment = MainAxisAlignment.start,
    MainAxisSize mainAxisSize = MainAxisSize.max,
    CrossAxisAlignment crossAxisAlignment = CrossAxisAlignment.center,
    TextBaseline textBaseline,
    ContextCallback onPressed,
    ContextCallback onLongPressed,
    HitTestBehavior behavior = HitTestBehavior.opaque,
    double itemSpacing = 0,
    Widget divider,
    bool visible,
    bool expanded,
    bool forceItemSameExtent = false,
    double elevation,
    bool material = false,
    bool safeArea,
    TextStyle textStyle,
    GlobalKey repaintBoundaryKey,
    double widthFactor,
    bool scrollable,
    bool withLocalNavigator,
    Duration animationDuration,
    Curve animationCurve,
    ThemeData theme,
    Widget topEnd,
    List<Widget> children,
  }) : super(
          key: key,
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
          forceItemSameExtent: forceItemSameExtent,
          safeArea: safeArea,
          divider: divider,
          elevation: elevation,
          material: material,
          widthFactor: widthFactor,
          textStyle: textStyle,
          repaintBoundaryKey: repaintBoundaryKey,
          scrollable: scrollable,
          animationDuration: animationDuration,
          animationCurve: animationCurve,
          withLocalNavigator: withLocalNavigator,
          theme: theme,
          topEnd: topEnd,
          children: children,
        );
}

class DecoratedColumn extends DecoratedFlex {
  const DecoratedColumn({
    Key key,
    EdgeInsets padding,
    EdgeInsets margin,
    Color color,
    Decoration decoration,
    Decoration foregroundDecoration,
    BoxConstraints constraints,
    Matrix4 transform,
    double width,
    double height,
    AlignmentGeometry alignment,
    MainAxisAlignment mainAxisAlignment = MainAxisAlignment.start,
    MainAxisSize mainAxisSize = MainAxisSize.max,
    CrossAxisAlignment crossAxisAlignment = CrossAxisAlignment.center,
    TextBaseline textBaseline,
    ContextCallback onPressed,
    ContextCallback onLongPressed,
    HitTestBehavior behavior = HitTestBehavior.opaque,
    double itemSpacing = 0,
    Widget divider,
    bool visible,
    bool expanded,
    bool forceItemSameExtent = false,
    double elevation,
    bool material = false,
    bool safeArea,
    TextStyle textStyle,
    GlobalKey repaintBoundaryKey,
    double heightFactor,
    bool scrollable,
    bool withLocalNavigator,
    Duration animationDuration,
    Curve animationCurve,
    ThemeData theme,
    Widget topEnd,
    List<Widget> children,
  }) : super(
          key: key,
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
          forceItemSameExtent: forceItemSameExtent,
          safeArea: safeArea,
          divider: divider,
          elevation: elevation,
          material: material,
          heightFactor: heightFactor,
          textStyle: textStyle,
          repaintBoundaryKey: repaintBoundaryKey,
          scrollable: scrollable,
          animationDuration: animationDuration,
          animationCurve: animationCurve,
          withLocalNavigator: withLocalNavigator,
          theme: theme,
          topEnd: topEnd,
          children: children,
        );
}

class DecoratedFlex extends StatelessWidget {
  const DecoratedFlex({
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
    this.divider,
    this.visible,
    this.expanded,
    this.forceItemSameExtent = false,
    this.elevation,
    this.safeArea,
    this.withLocalNavigator = false,
    this.scrollable,
    this.widthFactor,
    this.heightFactor,
    this.material = false,
    this.textStyle,
    this.repaintBoundaryKey,
    this.animationDuration,
    this.animationCurve,
    this.theme,
    this.topEnd,
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

  //region Material
  final bool material;
  final double elevation;

  //endregion

  //region FractionallySizedBox
  final double widthFactor;
  final double heightFactor;

  //endregion

  /// 元素间距
  final double itemSpacing;

  /// 分隔控件 与[itemSpacing]功能类似, 但是优先使用[divider]
  final Widget divider;

  /// 是否可见
  final bool visible;

  /// 是否展开
  final bool expanded;

  /// 是否强制子控件等长
  final bool forceItemSameExtent;

  /// 是否安全区域
  final bool safeArea;

  /// 是否可滚动
  final bool scrollable;

  /// 是否带有局部Navigator 简单来说就是要不要用[CupertinoTabView]包裹
  final bool withLocalNavigator;

  /// 内部统一的TextStyle
  final TextStyle textStyle;

  /// 是否需要[RepaintBoundary]
  final GlobalKey repaintBoundaryKey;

  /// 动画时长
  final Duration animationDuration;

  /// 动画曲线
  final Curve animationCurve;

  /// 主题
  final ThemeData theme;

  /// 右上角控件
  final Widget topEnd;

  /// 子元素
  final List<Widget> children;

  @override
  Widget build(BuildContext context) {
    List<Widget> _children = children;

    if (forceItemSameExtent) {
      _children = children.map((it) {
        switch (direction) {
          case Axis.horizontal:
            return SizedBox(
              width: MediaQuery.of(context).size.width / children.length,
              child: it,
            );
          case Axis.vertical:
            return SizedBox(
              height: MediaQuery.of(context).size.height / children.length,
              child: it,
            );
          default:
            return null;
        }
      }).toList();
    }

    Widget result = Flex(
      direction: direction,
      mainAxisAlignment: mainAxisAlignment,
      mainAxisSize: mainAxisSize,
      crossAxisAlignment: crossAxisAlignment,
      textBaseline: textBaseline,
      children: itemSpacing != 0 || divider != null
          ? addItemDivider(_children, itemSpacing, divider)
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
      if (animationDuration != null && animationDuration != Duration.zero) {
        result = AnimatedContainer(
          duration: animationDuration,
          curve: animationCurve ?? Curves.linear,
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
      } else {
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

    if (material || elevation != null) {
      result = Material(
        elevation: elevation ?? 0,
        color: color,
        child: result,
      );
    }

    if (safeArea != null) {
      result = SafeArea(child: result);
    }

    if (widthFactor != null || heightFactor != null) {
      result = FractionallySizedBox(
        widthFactor: widthFactor,
        heightFactor: heightFactor,
        child: result,
      );
    }

    if (textStyle != null) {
      result = DefaultTextStyle(style: textStyle, child: result);
    }

    if (repaintBoundaryKey != null) {
      result = RepaintBoundary(key: repaintBoundaryKey, child: result);
    }

    if (withLocalNavigator == true) {
      return CupertinoTabView(builder: (context) => result);
    }

    if (scrollable == true) {
      result = SingleChildScrollView(child: result, scrollDirection: direction);
    }

    if (visible != null) {
      result = Visibility(visible: visible, child: result);
    }

    if (theme != null) {
      result = Theme(data: theme, child: result);
    }

    if (topEnd != null) {
      result = Stack(children: <Widget>[
        result,
        Positioned(top: 0, right: 0, child: topEnd),
      ]);
    }

    if (expanded == true) {
      result = Expanded(child: result);
    }

    return result;
  }

  List<Widget> addItemDivider(
    List<Widget> children,
    double itemSpacing,
    Widget divider,
  ) {
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
          children.insert(index, divider ?? SizedBox(width: itemSpacing));
        });
      } else if (direction == Axis.vertical) {
        indexes.forEach((index) {
          children.insert(index, divider ?? SizedBox(height: itemSpacing));
        });
      }
    }

    return children;
  }
}
