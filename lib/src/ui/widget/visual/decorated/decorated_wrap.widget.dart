import 'package:flutter/material.dart';

class DecoratedWrap extends StatelessWidget {
  const DecoratedWrap({
    super.key,
    this.width,
    this.height,
    this.direction = Axis.horizontal,
    this.alignment = WrapAlignment.start,
    this.runAlignment = WrapAlignment.start,
    this.spacing = 0.0,
    this.runSpacing = 0.0,
    this.crossAxisAlignment = WrapCrossAlignment.start,
    this.textDirection,
    this.verticalDirection = VerticalDirection.down,
    this.clipBehavior = Clip.none,
    this.padding,
    this.margin,
    this.expanded,
    this.textStyle,
    this.crossAxisCount,
    this.childAspectRatio,
    this.decoration,
    this.foregroundDecoration,
    this.alignItemWidth = false,
    required this.children,
  });

  final double? width, height;
  final int? crossAxisCount;
  final Axis direction;
  final WrapAlignment alignment;
  final WrapAlignment runAlignment;
  final double spacing;
  final double runSpacing;
  final WrapCrossAlignment crossAxisAlignment;
  final TextDirection? textDirection;
  final VerticalDirection verticalDirection;
  final EdgeInsets? padding;
  final EdgeInsets? margin;
  final bool? expanded;
  final TextStyle? textStyle;
  final Clip clipBehavior;
  final double? childAspectRatio;
  final BoxDecoration? decoration;
  final BoxDecoration? foregroundDecoration;

  /// 是否对item进行floor对齐
  ///
  /// 如果double计算时出现略微的溢出导致换行, 就设置这个为true, 默认false
  final bool alignItemWidth;
  final List<Widget> children;

  @override
  Widget build(BuildContext context) {
    Widget result;
    if (crossAxisCount != null) {
      result = LayoutBuilder(
        builder: (context, constraints) {
          // 空白部分宽度, 比如一行为2个时, 空余宽度为 (2-1)*spacing;
          final spaceWidth = (crossAxisCount! - 1) * spacing;
          final availableWidth = constraints.maxWidth - spaceWidth;
          var itemWidth = availableWidth / crossAxisCount!;
          if (alignItemWidth) {
            itemWidth = itemWidth.floorToDouble();
          }
          return Wrap(
            direction: direction,
            alignment: alignment,
            runAlignment: runAlignment,
            runSpacing: runSpacing,
            spacing: spacing,
            crossAxisAlignment: crossAxisAlignment,
            textDirection: textDirection,
            verticalDirection: verticalDirection,
            clipBehavior: clipBehavior,
            children: [
              for (final item in children)
                SizedBox(
                  width: itemWidth,
                  height: childAspectRatio == null
                      ? null
                      : itemWidth / childAspectRatio!,
                  child: item,
                ),
            ],
          );
        },
      );
    } else {
      result = Wrap(
        direction: direction,
        alignment: alignment,
        runAlignment: runAlignment,
        runSpacing: runSpacing,
        spacing: spacing,
        crossAxisAlignment: crossAxisAlignment,
        textDirection: textDirection,
        verticalDirection: verticalDirection,
        clipBehavior: clipBehavior,
        children: children,
      );
    }

    if (width != null ||
        height != null ||
        padding != null ||
        margin != null ||
        decoration != null ||
        foregroundDecoration != null) {
      result = Container(
        width: width,
        height: height,
        padding: padding,
        margin: margin,
        decoration: decoration,
        foregroundDecoration: foregroundDecoration,
        child: result,
      );
    }

    if (textStyle != null) {
      result = DefaultTextStyle(
        style: textStyle!,
        child: result,
      );
    }

    if (expanded == true) {
      result = Expanded(child: result);
    }

    return result;
  }
}
