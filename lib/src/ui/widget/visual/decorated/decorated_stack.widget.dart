import 'package:decorated_flutter/decorated_flutter.dart';
import 'package:flutter/material.dart';

enum ZIndex {
  top,
  bottom,
}

class DecoratedStack extends StatelessWidget {
  const DecoratedStack({
    Key key,
    this.padding,
    this.margin,
    this.decoration,
    this.width,
    this.height,
    this.textStyle,
    this.safeArea,
    this.onPressed,
    this.onLongPressed,
    this.onVerticalDragEnd,
    this.onHorizontalDragEnd,
    this.behavior,
    this.overflow,
    this.constraints,
    this.expanded = false,
    this.stackFit,
    this.alignment,
    this.topStart,
    this.topEnd,
    this.bottomStart,
    this.bottomEnd,
    this.top,
    this.bottom,
    this.start,
    this.end,
    this.center,
    this.sliver = false,
    this.aspectRatio,
    this.childrenZIndex = ZIndex.bottom,
    this.transform,
    this.animationDuration,
    this.animationCurve,
    this.clipBehavior,
    this.children = const [],
  }) : super(key: key);

  final EdgeInsetsGeometry padding;
  final EdgeInsetsGeometry margin;
  final BoxDecoration decoration;
  final BoxConstraints constraints;
  final double width;
  final double height;
  final Matrix4 transform;
  final Duration animationDuration;
  final Curve animationCurve;

  final TextStyle textStyle;

  final SafeAreaConfig safeArea;

  final ContextCallback onPressed;
  final ContextCallback onLongPressed;
  final GestureDragEndCallback onVerticalDragEnd;
  final GestureDragEndCallback onHorizontalDragEnd;
  final HitTestBehavior behavior;

  final bool expanded;

  final Widget topStart;
  final Widget topEnd;
  final Widget bottomStart;
  final Widget bottomEnd;
  final Widget top;
  final Widget bottom;
  final Widget start;
  final Widget end;
  final Widget center;

  final StackFit stackFit;
  final AlignmentGeometry alignment;
  final Overflow overflow;

  final bool sliver;
  final ZIndex childrenZIndex;

  final double aspectRatio;

  final Clip clipBehavior;

  final List<Widget> children;

  @override
  Widget build(BuildContext context) {
    Widget result = Stack(
      alignment: alignment ?? AlignmentDirectional.topStart,
      fit: stackFit ?? StackFit.loose,
      overflow: overflow ?? Overflow.clip,
      children: <Widget>[
        if (childrenZIndex == ZIndex.bottom) ...children,
        if (topStart != null) Positioned(top: 0, left: 0, child: topStart),
        if (topEnd != null) Positioned(top: 0, right: 0, child: topEnd),
        if (bottomStart != null)
          Positioned(bottom: 0, left: 0, child: bottomStart),
        if (bottomEnd != null)
          Positioned(bottom: 0, right: 0, child: bottomEnd),
        if (top != null) Positioned(top: 0, left: 0, right: 0, child: top),
        if (bottom != null)
          Positioned(bottom: 0, right: 0, left: 0, child: bottom),
        if (start != null) Positioned(bottom: 0, top: 0, left: 0, child: start),
        if (end != null) Positioned(bottom: 0, top: 0, right: 0, child: end),
        if (center != null)
          Positioned(bottom: 0, right: 0, top: 0, left: 0, child: center),
        if (childrenZIndex == ZIndex.top) ...children,
      ],
    );

    if (aspectRatio != null) {
      result = AspectRatio(aspectRatio: aspectRatio, child: result);
    }

    if (safeArea != null) {
      result = SafeArea(
        child: result,
        top: safeArea.top ?? true,
        bottom: safeArea.bottom ?? true,
        left: safeArea.left ?? true,
        right: safeArea.right ?? true,
      );
    }

    if (textStyle != null) {
      result = DefaultTextStyle(style: textStyle, child: result);
    }

    if (decoration != null ||
        padding != null ||
        margin != null ||
        width != null ||
        height != null ||
        transform != null ||
        constraints != null) {
      if (animationDuration != null && animationDuration != Duration.zero) {
        result = AnimatedContainer(
          duration: animationDuration,
          curve: animationCurve ?? Curves.linear,
          padding: padding,
          margin: margin,
          width: width,
          height: height,
          decoration: decoration,
          constraints: constraints,
          transform: transform,
          child: result,
        );
      } else {
        result = Container(
          padding: padding,
          margin: margin,
          width: width,
          height: height,
          decoration: decoration,
          constraints: constraints,
          clipBehavior: clipBehavior,
          transform: transform,
          child: result,
        );
      }
    }

    if (onPressed != null ||
        onLongPressed != null ||
        onVerticalDragEnd != null ||
        onHorizontalDragEnd != null) {
      result = GestureDetector(
        behavior: behavior,
        onTap: () => onPressed?.call(context),
        onLongPress: () => onLongPressed?.call(context),
        onVerticalDragEnd: onVerticalDragEnd,
        onHorizontalDragEnd: onHorizontalDragEnd,
        child: result,
      );
    }

    if (expanded) {
      result = Expanded(child: result);
    }

    if (sliver) {
      result = SliverToBoxAdapter(child: result);
    }
    return result;
  }
}
