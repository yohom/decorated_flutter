import 'package:flutter/widgets.dart';

class Circle extends StatelessWidget {
  const Circle({
    Key key,
    @required this.radius,
    @required this.color,
  }) : super(key: key);

  final double radius;
  final Color color;

  @override
  Widget build(BuildContext context) {
    return Container(
      width: radius,
      height: radius,
      decoration: BoxDecoration(color: color, shape: BoxShape.circle),
    );
  }
}

class Square extends StatelessWidget {
  const Square({
    Key key,
    @required this.side,
    @required this.color,
  }) : super(key: key);

  final double side;
  final Color color;

  @override
  Widget build(BuildContext context) {
    return Container(
      width: side,
      height: side,
      decoration: BoxDecoration(color: color, shape: BoxShape.rectangle),
    );
  }
}
