import 'package:flutter/material.dart';

class DecoratedText extends StatelessWidget {
  const DecoratedText(
    this.data, {
    Key key,
    this.padding,
    this.margin,
    this.decoration,
    this.style = const TextStyle(),
    this.safeArea,
    this.onPressed,
    this.maxLines,
    this.textAlign,
    this.constraints,
  }) : super(key: key);

  final EdgeInsetsGeometry padding;
  final EdgeInsetsGeometry margin;
  final BoxDecoration decoration;
  final TextStyle style;
  final String data;
  final bool safeArea;
  final ValueChanged<String> onPressed;
  final int maxLines;
  final TextAlign textAlign;
  final BoxConstraints constraints;

  @override
  Widget build(BuildContext context) {
    Widget result = Text(
      data,
      maxLines: maxLines,
      style: style,
      textAlign: textAlign,
    );

    if (decoration != null || padding != null || margin != null) {
      result = Container(
        margin: margin,
        padding: padding,
        decoration: decoration,
        constraints: constraints,
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
