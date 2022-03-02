import 'package:decorated_flutter/src/model/model.export.dart';
import 'package:decorated_flutter/src/utils/utils.export.dart';
import 'package:flutter/material.dart';

class DecoratedText extends StatelessWidget {
  const DecoratedText(
    this.data, {
    Key? key,
    this.padding,
    this.margin,
    this.decoration,
    this.foregroundDecoration,
    this.style,
    this.strutStyle = const StrutStyle(),
    this.safeArea,
    this.onPressed,
    this.maxLines,
    this.textAlign,
    this.overflow = TextOverflow.ellipsis,
    this.constraints,
    this.expanded = false,
    this.visible,
    this.width,
    this.height,
    this.center,
    this.transform,
    this.sliver,
    this.leftWidget,
    this.rightWidget,
    this.softWrap = true,
    this.material,
    this.mainAxisAlignment,
    this.crossAxisAlignment,
    this.textBaseline,
    this.behavior,
    this.textExpanded = false,
    this.textFlexible = false,
  }) : super(key: key);

  /// 内边距
  final EdgeInsetsGeometry? padding;

  /// 外边距
  final EdgeInsetsGeometry? margin;

  /// 作用于Container的decoration
  final BoxDecoration? decoration;
  final BoxDecoration? foregroundDecoration;
  final TextStyle? style;
  final StrutStyle strutStyle;
  final String data;
  final SafeAreaConfig? safeArea;
  final ContextCallback? onPressed;
  final int? maxLines;
  final TextAlign? textAlign;
  final TextOverflow overflow;
  final BoxConstraints? constraints;
  final bool expanded;
  final double? width;
  final double? height;
  final bool? visible;
  final bool? center;
  final bool? sliver;
  final Matrix4? transform;
  final Widget? leftWidget;
  final Widget? rightWidget;
  final bool softWrap;
  final bool? material;
  final MainAxisAlignment? mainAxisAlignment;
  final CrossAxisAlignment? crossAxisAlignment;
  final TextBaseline? textBaseline;
  final HitTestBehavior? behavior;
  final bool textExpanded;
  final bool textFlexible;

  @override
  Widget build(BuildContext context) {
    Widget result = Text(
      data,
      maxLines: maxLines,
      style: style ?? DefaultTextStyle.of(context).style,
      strutStyle: strutStyle,
      textAlign: textAlign,
      overflow: overflow,
      softWrap: softWrap,
    );

    if (rightWidget != null || leftWidget != null) {
      result = Row(
        mainAxisAlignment: mainAxisAlignment ?? MainAxisAlignment.center,
        crossAxisAlignment: crossAxisAlignment ?? CrossAxisAlignment.center,
        textBaseline: textBaseline,
        children: [
          if (leftWidget != null) leftWidget!,
          if (textExpanded)
            Expanded(child: result)
          else if (textFlexible)
            Flexible(child: result)
          else
            result,
          if (rightWidget != null) rightWidget!,
        ],
      );
    }

    if (center == true) {
      result = Center(child: result);
    }

    if (width != null ||
        height != null ||
        decoration != null ||
        foregroundDecoration != null ||
        margin != null ||
        padding != null ||
        constraints != null ||
        transform != null) {
      result = Container(
        width: width,
        height: height,
        margin: margin,
        padding: padding,
        decoration: decoration,
        foregroundDecoration: foregroundDecoration,
        constraints: constraints,
        transform: transform,
        child: result,
      );
    }

    if (safeArea != null) {
      result = SafeArea(
        child: result,
        top: safeArea?.top ?? true,
        bottom: safeArea?.bottom ?? true,
        left: safeArea?.left ?? true,
        right: safeArea?.right ?? true,
      );
    }

    if (onPressed != null) {
      result = GestureDetector(
        behavior: behavior ?? HitTestBehavior.opaque,
        onTap: () => onPressed!(context),
        child: result,
      );
    }

    if (visible != null) {
      result = Visibility(visible: visible!, child: result);
    }

    if (material == true) {
      result = Material(color: Colors.transparent, child: result);
    }

    if (expanded == true) {
      result = Expanded(child: result);
    }

    if (sliver == true) {
      result = SliverToBoxAdapter(child: result);
    }

    return result;
  }
}
