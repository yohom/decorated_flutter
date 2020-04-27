import 'package:flutter/cupertino.dart';

class Start extends StatelessWidget {
  const Start({
    Key key,
    @required this.child,
    this.widthFactor,
    this.heightFactor,
  }) : super(key: key);

  final Widget child;
  final double widthFactor;
  final double heightFactor;

  @override
  Widget build(BuildContext context) {
    return Align(
      alignment: AlignmentDirectional.centerStart,
      widthFactor: widthFactor,
      heightFactor: heightFactor,
      child: child,
    );
  }
}

class End extends StatelessWidget {
  const End({
    Key key,
    @required this.child,
    this.widthFactor,
    this.heightFactor,
  }) : super(key: key);

  final Widget child;
  final double widthFactor;
  final double heightFactor;

  @override
  Widget build(BuildContext context) {
    return Align(
      alignment: AlignmentDirectional.centerEnd,
      widthFactor: widthFactor,
      heightFactor: heightFactor,
      child: child,
    );
  }
}

class Top extends StatelessWidget {
  const Top({
    Key key,
    @required this.child,
    this.widthFactor,
    this.heightFactor,
  }) : super(key: key);

  final Widget child;
  final double widthFactor;
  final double heightFactor;

  @override
  Widget build(BuildContext context) {
    return Align(
      alignment: AlignmentDirectional.topCenter,
      widthFactor: widthFactor,
      heightFactor: heightFactor,
      child: child,
    );
  }
}

class Bottom extends StatelessWidget {
  const Bottom({
    Key key,
    @required this.child,
    this.widthFactor,
    this.heightFactor,
  }) : super(key: key);

  final Widget child;
  final double widthFactor;
  final double heightFactor;

  @override
  Widget build(BuildContext context) {
    return Align(
      alignment: AlignmentDirectional.bottomCenter,
      widthFactor: widthFactor,
      heightFactor: heightFactor,
      child: child,
    );
  }
}
