import 'package:flutter/widgets.dart';

class Circle extends StatelessWidget {
  const Circle({
    Key key,
    @required this.radius,
    @required this.color,
    this.padding,
    this.margin,
    this.child,
  }) : super(key: key);

  final double radius;
  final Color color;
  final EdgeInsets padding;
  final EdgeInsets margin;
  final Widget child;

  @override
  Widget build(BuildContext context) {
    return Container(
      width: radius * 2,
      height: radius * 2,
      padding: padding,
      margin: margin,
      decoration: BoxDecoration(color: color, shape: BoxShape.circle),
      child: child,
    );
  }
}

class Square extends StatelessWidget {
  const Square({
    Key key,
    @required this.side,
    @required this.color,
    this.padding,
    this.margin,
    this.child,
  }) : super(key: key);

  final double side;
  final Color color;
  final EdgeInsets padding;
  final EdgeInsets margin;
  final Widget child;

  @override
  Widget build(BuildContext context) {
    return Container(
      width: side,
      height: side,
      padding: padding,
      margin: margin,
      decoration: BoxDecoration(color: color, shape: BoxShape.rectangle),
      child: child,
    );
  }
}
