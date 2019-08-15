import 'package:flutter/material.dart';

import '../../decorated_flutter.dart';

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
  }) : super(key: key);

  final BoxBorder border;
  final BorderRadiusGeometry borderRadius;
  final EdgeInsetsGeometry padding;
  final EdgeInsetsGeometry margin;
  final TextStyle style;
  final String data;
  final bool safeArea;
  final ContextCallback onPressed;

  @override
  Widget build(BuildContext context) {
    Widget result = Text(data, style: style);

    if (border != null ||
        borderRadius != null ||
        padding != null ||
        margin != null) {
      result = Container(
        margin: margin,
        padding: padding,
        decoration: BoxDecoration(
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
        onTap: () => onPressed(context),
        child: result,
      );
    }

    return result;
  }
}
