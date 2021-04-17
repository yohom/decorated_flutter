// @dart=2.9

import 'package:decorated_flutter/src/model/model.export.dart';
import 'package:decorated_flutter/src/utils/utils.export.dart';
import 'package:flutter/material.dart';

class DecoratedText extends StatelessWidget {
  const DecoratedText(
    this.data, {
    Key key,
    this.padding,
    this.margin,
    this.decoration,
    this.style,
    this.strutStyle = const StrutStyle(),
    this.safeArea,
    this.onPressed,
    this.maxLines,
    this.textAlign,
    this.overflow,
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
  }) : super(key: key);

  final EdgeInsetsGeometry padding;
  final EdgeInsetsGeometry margin;
  final BoxDecoration decoration;
  final TextStyle style;
  final StrutStyle strutStyle;
  final String data;
  final SafeAreaConfig safeArea;
  final ContextCallback onPressed;
  final int maxLines;
  final TextAlign textAlign;
  final TextOverflow overflow;
  final BoxConstraints constraints;
  final bool expanded;
  final double width;
  final double height;
  final bool visible;
  final bool center;
  final bool sliver;
  final Matrix4 transform;
  final Widget leftWidget;
  final Widget rightWidget;
  final bool softWrap;
  final bool material;
  final MainAxisAlignment mainAxisAlignment;

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

    if (center == true) {
      result = Center(child: result);
    }

    if (width != null ||
        height != null ||
        decoration != null ||
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
        constraints: constraints,
        transform: transform,
        child: result,
      );
    }

    if (rightWidget != null || leftWidget != null) {
      result = Row(
        mainAxisAlignment: mainAxisAlignment ?? MainAxisAlignment.center,
        children: [
          if (leftWidget != null) leftWidget,
          result,
          if (rightWidget != null) rightWidget,
        ],
      );
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

    if (onPressed != null) {
      result = GestureDetector(
        onTap: () => onPressed(context),
        child: result,
      );
    }

    if (visible != null) {
      result = Visibility(visible: visible, child: result);
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
