import 'package:decorated_flutter/decorated_flutter.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';

enum ZIndex {
  top,
  bottom,
}

class DecoratedStack extends StatelessWidget {
  const DecoratedStack({
    super.key,
    this.padding,
    this.margin,
    this.decoration,
    this.foregroundDecoration,
    this.width,
    this.height,
    this.textStyle,
    this.safeArea,
    this.onPressed,
    this.onLongPressed,
    this.onDoubleTap,
    this.onDoubleTapDown,
    this.onTapDown,
    this.onVerticalDragEnd,
    this.onHorizontalDragEnd,
    this.behavior,
    this.constraints,
    this.expanded = false,
    this.stackFit,
    this.alignment,
    this.topLeft,
    this.topRight,
    this.bottomLeft,
    this.bottomRight,
    this.top,
    this.bottom,
    this.left,
    this.right,
    this.center,
    this.fill,
    this.sliver = false,
    this.aspectRatio,
    this.childrenZIndex = ZIndex.bottom,
    this.transform,
    this.transformAlignment,
    this.animationDuration,
    this.animationCurve,
    this.clipBehavior = Clip.none,
    this.visible,
    this.systemUiOverlayStyle,
    this.repaintBoundaryKey,
    this.children = const [],
  });

  final EdgeInsetsGeometry? padding;
  final EdgeInsetsGeometry? margin;
  final BoxDecoration? decoration;
  final BoxDecoration? foregroundDecoration;
  final BoxConstraints? constraints;
  final double? width;
  final double? height;
  final Matrix4? transform;
  final Alignment? transformAlignment;
  final Duration? animationDuration;
  final Curve? animationCurve;

  final TextStyle? textStyle;

  final SafeAreaConfig? safeArea;

  final ContextCallback? onPressed;
  final ContextCallback? onDoubleTap;
  final ContextValueChanged<TapDownDetails>? onDoubleTapDown;
  final ContextValueChanged<TapDownDetails>? onTapDown;
  final ContextCallback? onLongPressed;
  final GestureDragEndCallback? onVerticalDragEnd;
  final GestureDragEndCallback? onHorizontalDragEnd;
  final HitTestBehavior? behavior;

  final bool expanded;

  final Widget? topLeft,
      topRight,
      bottomLeft,
      bottomRight,
      top,
      bottom,
      left,
      right,
      center,
      fill;

  final StackFit? stackFit;
  final AlignmentGeometry? alignment;

  final bool sliver;
  final ZIndex? childrenZIndex;

  final double? aspectRatio;

  final Clip clipBehavior;
  final bool? visible;
  final SystemUiOverlayStyle? systemUiOverlayStyle;
  final GlobalKey? repaintBoundaryKey;

  final List<Widget> children;

  @override
  Widget build(BuildContext context) {
    Widget result = Stack(
      alignment: alignment ?? AlignmentDirectional.topStart,
      fit: stackFit ?? StackFit.loose,
      clipBehavior: clipBehavior,
      children: <Widget>[
        if (childrenZIndex == ZIndex.bottom) ...children,
        // 填满
        if (fill != null)
          Positioned(bottom: 0, right: 0, top: 0, left: 0, child: fill!),
        // 中间
        if (center != null)
          Positioned(
            bottom: 0,
            right: 0,
            top: 0,
            left: 0,
            child: Center(child: center!),
          ),
        // 左上
        if (topLeft != null) Positioned(top: 0, left: 0, child: topLeft!),
        // 右上
        if (topRight != null) Positioned(top: 0, right: 0, child: topRight!),
        // 左下
        if (bottomLeft != null)
          Positioned(bottom: 0, left: 0, child: bottomLeft!),
        // 右下
        if (bottomRight != null)
          Positioned(bottom: 0, right: 0, child: bottomRight!),
        // 上
        if (top != null) Positioned(top: 0, left: 0, right: 0, child: top!),
        // 下
        if (bottom != null)
          Positioned(bottom: 0, right: 0, left: 0, child: bottom!),
        // 左
        if (left != null) Positioned(bottom: 0, top: 0, left: 0, child: left!),
        // 右
        if (right != null)
          Positioned(bottom: 0, top: 0, right: 0, child: right!),
        if (childrenZIndex == ZIndex.top) ...children,
      ],
    );

    if (aspectRatio != null) {
      result = AspectRatio(aspectRatio: aspectRatio!, child: result);
    }

    if (safeArea != null && safeArea!.inner) {
      result = SafeArea(
        top: safeArea?.top ?? true,
        bottom: safeArea?.bottom ?? true,
        left: safeArea?.left ?? true,
        right: safeArea?.right ?? true,
        minimum: safeArea?.minimum ?? EdgeInsets.zero,
        child: result,
      );
    }

    if (textStyle != null) {
      result = DefaultTextStyle(style: textStyle!, child: result);
    }

    if (decoration != null ||
        foregroundDecoration != null ||
        padding != null ||
        margin != null ||
        width != null ||
        height != null ||
        transform != null ||
        constraints != null) {
      if (animationDuration != null && animationDuration != Duration.zero) {
        result = AnimatedContainer(
          duration: animationDuration!,
          foregroundDecoration: foregroundDecoration,
          curve: animationCurve ?? Curves.linear,
          padding: padding,
          margin: margin,
          width: width,
          height: height,
          decoration: decoration,
          constraints: constraints,
          transform: transform,
          transformAlignment: transformAlignment,
          child: result,
        );
      } else {
        result = Container(
          padding: padding,
          foregroundDecoration: foregroundDecoration,
          margin: margin,
          width: width,
          height: height,
          decoration: decoration,
          constraints: constraints,
          clipBehavior: clipBehavior,
          transform: transform,
          transformAlignment: transformAlignment,
          child: result,
        );
      }
    }

    if (onPressed != null ||
        onDoubleTap != null ||
        onTapDown != null ||
        onDoubleTapDown != null ||
        onLongPressed != null ||
        onVerticalDragEnd != null ||
        onHorizontalDragEnd != null) {
      result = MouseRegion(
        cursor: SystemMouseCursors.click,
        child: GestureDetector(
          behavior: behavior,
          onDoubleTapDown: onDoubleTapDown == null
              ? null
              : (details) => onDoubleTapDown!(context, details),
          onDoubleTap: onDoubleTap == null ? null : () => onDoubleTap!(context),
          onTapDown: onTapDown == null
              ? null
              : (detail) => onTapDown!(context, detail),
          onTap: onPressed == null ? null : () => onPressed!(context),
          onLongPress:
              onLongPressed == null ? null : () => onLongPressed!(context),
          onVerticalDragEnd: onVerticalDragEnd,
          onHorizontalDragEnd: onHorizontalDragEnd,
          child: result,
        ),
      );
    }

    if (safeArea != null && !safeArea!.inner) {
      result = SafeArea(
        top: safeArea?.top ?? true,
        bottom: safeArea?.bottom ?? true,
        left: safeArea?.left ?? true,
        right: safeArea?.right ?? true,
        minimum: safeArea?.minimum ?? EdgeInsets.zero,
        child: result,
      );
    }

    if (visible != null) {
      result = Visibility(visible: visible!, child: result);
    }

    if (systemUiOverlayStyle != null) {
      result = AnnotatedRegion(value: systemUiOverlayStyle!, child: result);
    }

    if (repaintBoundaryKey != null) {
      result = RepaintBoundary(key: repaintBoundaryKey, child: result);
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

class TopLeftPositioned extends StatelessWidget {
  const TopLeftPositioned(this.child, {super.key});

  final Widget child;

  @override
  Widget build(BuildContext context) {
    return Positioned(top: 0, left: 0, child: child);
  }
}

class TopRightPositioned extends StatelessWidget {
  const TopRightPositioned(this.child, {super.key});

  final Widget child;

  @override
  Widget build(BuildContext context) {
    return Positioned(top: 0, right: 0, child: child);
  }
}

class TopPositioned extends StatelessWidget {
  const TopPositioned(this.child, {super.key});

  final Widget child;

  @override
  Widget build(BuildContext context) {
    return Positioned(top: 0, left: 0, right: 0, child: child);
  }
}

class LeftPositioned extends StatelessWidget {
  const LeftPositioned(this.child, {super.key});

  final Widget child;

  @override
  Widget build(BuildContext context) {
    return Positioned(top: 0, bottom: 0, left: 0, child: child);
  }
}

class RightPositioned extends StatelessWidget {
  const RightPositioned(this.child, {super.key});

  final Widget child;

  @override
  Widget build(BuildContext context) {
    return Positioned(top: 0, bottom: 0, right: 0, child: child);
  }
}

class BottomLeftPositioned extends StatelessWidget {
  const BottomLeftPositioned(this.child, {super.key});

  final Widget child;

  @override
  Widget build(BuildContext context) {
    return Positioned(bottom: 0, left: 0, child: child);
  }
}

class BottomRightPositioned extends StatelessWidget {
  const BottomRightPositioned(this.child, {super.key});

  final Widget child;

  @override
  Widget build(BuildContext context) {
    return Positioned(bottom: 0, right: 0, child: child);
  }
}

class BottomPositioned extends StatelessWidget {
  const BottomPositioned(this.child, {super.key});

  final Widget child;

  @override
  Widget build(BuildContext context) {
    return Positioned(bottom: 0, right: 0, left: 0, child: child);
  }
}

class CenterPositioned extends StatelessWidget {
  const CenterPositioned(this.child, {super.key});

  final Widget child;

  @override
  Widget build(BuildContext context) {
    return Positioned(bottom: 0, right: 0, left: 0, top: 0, child: child);
  }
}
