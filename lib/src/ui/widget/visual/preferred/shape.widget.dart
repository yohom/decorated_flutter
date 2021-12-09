import 'package:flutter/material.dart';
import 'package:flutter/widgets.dart';

class Circle extends StatelessWidget {
  const Circle({
    Key? key,
    required this.radius,
    this.color = Colors.transparent,
    this.padding = EdgeInsets.zero,
    this.margin = EdgeInsets.zero,
    this.border,
    this.child,
  }) : super(key: key);

  final double radius;
  final Color color;
  final EdgeInsets padding;
  final EdgeInsets margin;
  final Border? border;
  final Widget? child;

  @override
  Widget build(BuildContext context) {
    return Container(
      width: radius * 2,
      height: radius * 2,
      padding: padding,
      margin: margin,
      decoration: BoxDecoration(
        color: color,
        shape: BoxShape.circle,
        border: border,
      ),
      child: child,
    );
  }
}

class Square extends StatelessWidget {
  const Square({
    Key? key,
    required this.side,
    this.color = Colors.transparent,
    this.padding = EdgeInsets.zero,
    this.margin = EdgeInsets.zero,
    this.border,
    this.child,
  }) : super(key: key);

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
    Key? key,
    required this.width,
    required this.height,
    this.color = Colors.grey,
    this.padding = EdgeInsets.zero,
    this.margin = EdgeInsets.zero,
  }) : super(key: key);

  final double width, height;
  final Color color;
  final EdgeInsets padding, margin;

  @override
  Widget build(BuildContext context) {
    return Container(
      width: width,
      height: height,
      padding: padding,
      margin: margin,
      decoration: BoxDecoration(
        color: color,
      ),
    );
  }
}
