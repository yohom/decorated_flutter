import 'package:decorated_flutter/src/extension/extension.export.dart';
import 'package:flutter/material.dart';

class Circle extends StatelessWidget {
  const Circle({
    super.key,
    required this.radius,
    this.color = Colors.transparent,
    this.padding = EdgeInsets.zero,
    this.margin = EdgeInsets.zero,
    this.border,
    this.alignment,
    this.decoration,
    this.child,
  });

  final double radius;
  final Color color;
  final EdgeInsets padding;
  final EdgeInsets margin;
  final Border? border;
  final Alignment? alignment;
  final BoxDecoration? decoration;
  final Widget? child;

  @override
  Widget build(BuildContext context) {
    return Container(
      width: radius * 2,
      height: radius * 2,
      padding: padding,
      margin: margin,
      alignment: alignment,
      decoration: decoration?.copyWith(shape: BoxShape.circle) ??
          BoxDecoration(color: color, shape: BoxShape.circle, border: border),
      child: child,
    );
  }
}

class Square extends StatelessWidget {
  const Square({
    super.key,
    required this.side,
    this.color = Colors.transparent,
    this.padding = EdgeInsets.zero,
    this.margin = EdgeInsets.zero,
    this.border,
    this.child,
  });

  final double side;
  final Color color;
  final EdgeInsets padding;
  final EdgeInsets margin;
  final Border? border;
  final Widget? child;

  @override
  Widget build(BuildContext context) {
    return Container(
      width: side,
      height: side,
      padding: padding,
      margin: margin,
      decoration: BoxDecoration(
        color: color,
        shape: BoxShape.rectangle,
        border: border,
      ),
      child: child,
    );
  }
}

class Line extends StatelessWidget {
  const Line({
    super.key,
    this.width = double.infinity,
    this.height = 1,
    this.color,
    this.borderRadius,
    this.centered,
    this.padding = EdgeInsets.zero,
    this.margin = const EdgeInsets.symmetric(vertical: 8),
  });

  final double width, height;
  final Color? color;
  final EdgeInsets padding, margin;
  final BorderRadius? borderRadius;
  final bool? centered;

  @override
  Widget build(BuildContext context) {
    Widget result = Container(
      width: width,
      height: height,
      padding: padding,
      margin: margin,
      decoration: BoxDecoration(
        color: color ?? context.theme.dividerTheme.color,
        borderRadius: borderRadius,
      ),
    );

    if (centered == true) {
      result = Center(child: result);
    }

    return result;
  }
}
