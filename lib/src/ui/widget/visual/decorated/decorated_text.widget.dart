import 'package:flutter/material.dart';

class DecoratedText extends StatelessWidget {
  const DecoratedText(
    this.data, {
    Key key,
    this.border,
    this.borderRadius,
    this.padding,
    this.margin,
    this.style = const TextStyle(),
    this.safeArea,
    this.onPressed,
    this.backgroundColor,
    this.maxLines,
    this.textAlign,
  }) : super(key: key);

  final BoxBorder border;
  final BorderRadiusGeometry borderRadius;
  final EdgeInsetsGeometry padding;
  final EdgeInsetsGeometry margin;
  final TextStyle style;
  final String data;
  final bool safeArea;
  final ValueChanged<String> onPressed;
  final Color backgroundColor;
  final int maxLines;
  final TextAlign textAlign;

  @override
  Widget build(BuildContext context) {
    Widget result = Text(
      data,
      maxLines: maxLines,
      style: style,
      textAlign: textAlign,
    );

    if (border != null ||
        borderRadius != null ||
        padding != null ||
        margin != null ||
        backgroundColor != null) {
      result = Container(
        margin: margin,
        padding: padding,
        decoration: BoxDecoration(
          color: backgroundColor,
          border: border,
          borderRadius: borderRadius,
        ),
        child: result,
      );
    }

    if (safeArea != null) {
      result = SafeArea(child: result);
    }

    if (onPressed != null) {
      result = GestureDetector(
        onTap: () => onPressed(data),
        child: result,
      );
    }

    return result;
  }
}
