import 'package:decorated_flutter/decorated_flutter.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';

class DecoratedRow extends DecoratedFlex {
  const DecoratedRow({
    super.key,
    super.padding,
    super.margin,
    super.color,
    super.decoration,
    super.foregroundDecoration,
    super.constraints,
    super.transform,
    super.offset,
    super.width,
    super.height,
    super.alignment,
    super.mainAxisAlignment = MainAxisAlignment.start,
    super.mainAxisSize = MainAxisSize.max,
    super.crossAxisAlignment = CrossAxisAlignment.center,
    super.textBaseline,
    super.onPressed,
    super.onLongPressed,
    super.onDoubleTap,
    super.onVerticalDragStart,
    super.onVerticalDragEnd,
    super.onHorizontalDragEnd,
    super.behavior,
    super.itemSpacing = 0,
    super.divider,
    super.visible,
    super.expanded,
    super.flexible,
    super.flex,
    super.forceItemSameExtent = false,
    super.elevation,
    super.material = false,
    super.safeArea,
    super.textStyle,
    super.repaintBoundaryKey,
    super.widthFactor,
    super.heightFactor,
    super.scrollable,
    super.primary,
    super.scrollController,
    super.scrollPhysics,
    super.animationDuration,
    super.animationCurve,
    super.theme,
    @Deprecated('使用topRight代替') Widget? topEnd,
    super.topRight,
    super.center,
    super.sliver = false,
    super.verticalDirection,
    super.clipBehavior = Clip.none,
    super.iconColor,
    super.systemOverlayStyle,
    super.ignorePointer,
    super.enableFeedback,
    super.autofillGroup,
    super.aspectRatio,
    super.reverse,
    super.children = const [],
  }) : super(direction: Axis.horizontal);
}

class DecoratedColumn extends DecoratedFlex {
  const DecoratedColumn({
    super.key,
    super.padding,
    super.margin,
    super.color,
    super.decoration,
    super.foregroundDecoration,
    super.constraints,
    super.transform,
    super.offset,
    super.width,
    super.height,
    super.alignment,
    super.mainAxisAlignment = MainAxisAlignment.start,
    super.mainAxisSize = MainAxisSize.max,
    super.crossAxisAlignment = CrossAxisAlignment.center,
    super.textBaseline,
    super.onPressed,
    super.onLongPressed,
    super.onDoubleTap,
    super.onVerticalDragStart,
    super.onVerticalDragEnd,
    super.onHorizontalDragEnd,
    super.behavior,
    super.itemSpacing = 0,
    super.divider,
    super.visible,
    super.expanded,
    super.flexible,
    super.withForm,
    super.flex,
    super.forceItemSameExtent = false,
    super.elevation,
    super.material = false,
    super.safeArea,
    super.textStyle,
    super.repaintBoundaryKey,
    super.widthFactor,
    super.heightFactor,
    super.scrollable,
    super.primary,
    super.scrollController,
    super.scrollPhysics,
    super.animationDuration,
    super.animationCurve,
    super.theme,
    @Deprecated('使用topRight代替') Widget? topEnd,
    super.topRight,
    super.center,
    super.sliver = false,
    super.verticalDirection,
    super.clipBehavior = Clip.none,
    super.iconColor,
    super.systemOverlayStyle,
    super.ignorePointer,
    super.enableFeedback,
    super.autofillGroup,
    super.aspectRatio,
    super.reverse,
    super.children = const [],
  }) : super(direction: Axis.vertical);
}

class DecoratedFlex extends StatelessWidget {
  const DecoratedFlex({
    Key? key,
    this.padding,
    this.margin,
    this.color,
    this.decoration,
    this.foregroundDecoration,
    this.constraints,
    this.transform,
    this.offset,
    this.width,
    this.height,
    required this.direction,
    this.alignment,
    this.mainAxisAlignment = MainAxisAlignment.start,
    this.mainAxisSize = MainAxisSize.max,
    this.crossAxisAlignment = CrossAxisAlignment.center,
    this.textBaseline,
    this.onPressed,
    this.onLongPressed,
    this.onDoubleTap,
    this.onVerticalDragStart,
    this.onVerticalDragEnd,
    this.onHorizontalDragEnd,
    this.behavior,
    this.itemSpacing = 0,
    this.divider,
    this.visible,
    this.expanded,
    this.flexible,
    this.withForm,
    this.flex,
    this.forceItemSameExtent = false,
    this.elevation,
    this.safeArea,
    this.scrollable,
    this.primary,
    this.scrollController,
    this.scrollPhysics,
    this.widthFactor,
    this.heightFactor,
    this.material = false,
    this.textStyle,
    this.repaintBoundaryKey,
    this.animationDuration,
    this.animationCurve,
    this.theme,
    this.topRight,
    this.center,
    this.sliver = false,
    this.verticalDirection,
    this.clipBehavior = Clip.none,
    this.iconColor,
    this.systemOverlayStyle,
    this.ignorePointer,
    this.enableFeedback,
    this.autofillGroup,
    this.aspectRatio,
    this.reverse,
    this.children = const [],
  }) : super(key: key);

  //region Container
  final EdgeInsets? padding;
  final EdgeInsets? margin;
  final Color? color;
  final Decoration? decoration;
  final Decoration? foregroundDecoration;
  final BoxConstraints? constraints;
  final Matrix4? transform;
  final double? width;
  final double? height;

  //endregion

  //region Flex
  final Axis direction;
  final AlignmentGeometry? alignment;
  final MainAxisAlignment mainAxisAlignment;
  final MainAxisSize mainAxisSize;
  final CrossAxisAlignment crossAxisAlignment;
  final TextBaseline? textBaseline;

  //endregion

  //region GestureDetector
  final ContextCallback? onPressed;
  final ContextCallback? onLongPressed;
  final ContextCallback? onDoubleTap;
  final GestureDragStartCallback? onVerticalDragStart;
  final GestureDragEndCallback? onVerticalDragEnd;
  final GestureDragEndCallback? onHorizontalDragEnd;
  final HitTestBehavior? behavior;

  //endregion

  //region Material
  final bool material;
  final double? elevation;

  //endregion

  //region FractionallySizedBox
  final double? widthFactor;
  final double? heightFactor;

  //endregion

  /// 元素间距
  final double? itemSpacing;

  /// 分隔控件 与[itemSpacing]功能类似, 但是优先使用[divider]
  final Widget? divider;

  /// 是否可见
  final bool? visible;

  /// 是否展开
  final bool? expanded;

  /// 是否展开
  final bool? flexible;

  /// 比例
  final int? flex;

  /// 是否强制子控件等长
  final bool? forceItemSameExtent;

  /// 是否安全区域
  final SafeAreaConfig? safeArea;

  /// 作用在Transform.translate上的偏移量
  final Offset? offset;

  /// 滚动相关
  final bool? scrollable;
  final bool? primary;
  final ScrollController? scrollController;
  final ScrollPhysics? scrollPhysics;

  /// 内部统一的TextStyle
  final TextStyle? textStyle;

  /// 是否需要[RepaintBoundary]
  final GlobalKey? repaintBoundaryKey;

  /// 动画时长
  final Duration? animationDuration;

  /// 动画曲线
  final Curve? animationCurve;

  /// 主题
  final ThemeData? theme;

  /// 右上角控件
  final Widget? topRight;

  /// 是否加center
  final bool? center;

  /// 是否sliver
  final bool? sliver;

  /// 垂直方向
  final VerticalDirection? verticalDirection;

  final Clip clipBehavior;

  final Color? iconColor;

  final SystemUiOverlayStyle? systemOverlayStyle;

  /// 是否忽略指针事件
  final bool? ignorePointer;

  final bool? enableFeedback;

  /// 自动填充组
  final bool? autofillGroup;

  /// 宽高比
  final double? aspectRatio;

  /// 是否带有表单
  final bool? withForm;

  /// 是否反向排列
  final bool? reverse;

  /// 子元素
  final List<Widget> children;

  @override
  Widget build(BuildContext context) {
    List<Widget> _children = children;

    if (reverse == true) {
      _children = _children.reversed.toList();
    }

    if (forceItemSameExtent == true) {
      _children = children.map<Widget>((it) => Expanded(child: it)).toList();
    }

    // 如果有reverse, 则对start和end的场景做一下翻转
    MainAxisAlignment _mainAxisAlignment = mainAxisAlignment;
    if (reverse == true) {
      if (_mainAxisAlignment == MainAxisAlignment.start) {
        _mainAxisAlignment = MainAxisAlignment.end;
      } else if (_mainAxisAlignment == MainAxisAlignment.end) {
        _mainAxisAlignment = MainAxisAlignment.start;
      }
    }
    Widget result = Flex(
      direction: direction,
      mainAxisAlignment: _mainAxisAlignment,
      mainAxisSize: mainAxisSize,
      crossAxisAlignment: crossAxisAlignment,
      textBaseline: textBaseline,
      verticalDirection: verticalDirection ?? VerticalDirection.down,
      children: itemSpacing != 0 || divider != null
          ? _addItemDivider(_children, itemSpacing!, divider)
          : _children,
    );

    if (autofillGroup == true) {
      result = AutofillGroup(child: result);
    }

    if (safeArea != null) {
      result = SafeArea(
        top: safeArea?.top ?? true,
        bottom: safeArea?.bottom ?? true,
        left: safeArea?.left ?? true,
        right: safeArea?.right ?? true,
        child: result,
      );
    }

    if (topRight != null) {
      result = Stack(children: <Widget>[
        result,
        Positioned(top: 0, right: 0, child: topRight!),
      ]);
    }

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
          duration: animationDuration!,
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
          clipBehavior: clipBehavior,
          child: result,
        );
      }
    }

    if (widthFactor != null || heightFactor != null) {
      result = FractionallySizedBox(
        widthFactor: widthFactor,
        heightFactor: heightFactor,
        child: result,
      );
    }

    final borderRadius = () {
      final shadow = decoration;
      if (shadow is BoxDecoration) {
        return shadow.borderRadius as BorderRadius?;
      } else {
        return null;
      }
    }();
    if (enableFeedback == true) {
      result = InkWell(
        borderRadius: borderRadius,
        onTap: onPressed != null ? () => onPressed!(context) : null,
        onLongPress:
            onLongPressed == null ? null : () => onLongPressed!(context),
        child: result,
      );
    } else if (onPressed != null ||
        onLongPressed != null ||
        onVerticalDragEnd != null ||
        onHorizontalDragEnd != null ||
        onDoubleTap != null) {
      result = GestureDetector(
        behavior: behavior ?? HitTestBehavior.opaque,
        onTap: onPressed == null ? null : () => onPressed!(context),
        onLongPress:
            onLongPressed == null ? null : () => onLongPressed!(context),
        onVerticalDragEnd: onVerticalDragEnd,
        onVerticalDragStart: onVerticalDragStart,
        onHorizontalDragEnd: onHorizontalDragEnd,
        onDoubleTap: onDoubleTap == null ? null : () => onDoubleTap!(context),
        child: result,
      );
    }

    // material要放在InkWell的上方, 否则没有波纹
    if (enableFeedback == true || material || elevation != null) {
      result = Material(
        borderRadius: borderRadius,
        elevation: elevation ?? 0,
        color: color,
        child: result,
      );
    }

    if (textStyle != null) {
      result = DefaultTextStyle(style: textStyle!, child: result);
    }

    if (repaintBoundaryKey != null) {
      result = RepaintBoundary(key: repaintBoundaryKey, child: result);
    }

    if (scrollable == true) {
      result = SingleChildScrollView(
        scrollDirection: direction,
        controller: scrollController,
        physics: scrollPhysics,
        primary: primary,
        child: result,
      );
    }

    if (withForm == true) {
      result = Form(child: result);
    }

    if (visible != null) {
      result = Visibility(visible: visible!, child: result);
    }

    if (theme != null) {
      result = Theme(data: theme!, child: result);
    }

    if (center == true) {
      result = Center(child: result);
    }

    if (aspectRatio != null) {
      result = AspectRatio(aspectRatio: aspectRatio!, child: result);
    }

    if (offset != null) {
      result = Transform.translate(offset: offset!, child: result);
    }

    if (iconColor != null) {
      result = IconTheme(data: IconThemeData(color: iconColor), child: result);
    }

    if (ignorePointer != null) {
      result = IgnorePointer(ignoring: ignorePointer!, child: result);
    }

    if (expanded == true) {
      result = Expanded(flex: flex ?? 1, child: result);
    }

    if (flexible == true) {
      result = Flexible(flex: flex ?? 1, child: result);
    }

    if (sliver == true) {
      result = SliverToBoxAdapter(child: result);
    }

    return result;
  }

  List<Widget> _addItemDivider(
    List<Widget> children,
    double itemSpacing,
    Widget? divider,
  ) {
    final result = List<Widget>.from(children);

    // 确认要往哪几个index(以最终的插入后的List为参考系)插空间
    int currentLength = result.length;
    if (currentLength > 1) {
      final indexes = <int>[];
      // `currentLength + (currentLength - 1)`是插入后的长度
      // 这里的循环是在纸上画过得出的结论
      for (int i = 1; i < currentLength + (currentLength - 1); i += 2) {
        indexes.add(i);
      }

      if (direction == Axis.horizontal) {
        for (var index in indexes) {
          result.insert(index, divider ?? SizedBox(width: itemSpacing));
        }
      } else if (direction == Axis.vertical) {
        for (var index in indexes) {
          result.insert(index, divider ?? SizedBox(height: itemSpacing));
        }
      }
    }

    return result;
  }
}
