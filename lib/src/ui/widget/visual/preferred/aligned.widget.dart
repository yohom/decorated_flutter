import 'package:flutter/cupertino.dart';

class Start extends StatelessWidget {
  const Start({
    Key key,
    @required this.child,
    this.widthFactor,
    this.heightFactor,
    this.padding,
  }) : super(key: key);

  final Widget child;
  final double widthFactor;
  final double heightFactor;
  final EdgeInsets padding;

  @override
  Widget build(BuildContext context) {
    Widget result = Align(
      alignment: AlignmentDirectional.centerStart,
      widthFactor: widthFactor,
      heightFactor: heightFactor,
      child: child,
    );

    if (padding != null) {
      result = Container(padding: padding, child: result);
    }
    return result;
  }
}

class End extends StatelessWidget {
  const End({
    Key key,
    @required this.child,
    this.widthFactor,
    this.heightFactor,
    this.padding,
  }) : super(key: key);

  final Widget child;
  final double widthFactor;
  final double heightFactor;
  final EdgeInsets padding;

  @override
  Widget build(BuildContext context) {
    Widget result = Align(
      alignment: AlignmentDirectional.centerEnd,
      widthFactor: widthFactor,
      heightFactor: heightFactor,
      child: child,
    );

    if (padding != null) {
      result = Container(padding: padding, child: result);
    }
    return result;
  }
}

class Top extends StatelessWidget {
  const Top({
    Key key,
    @required this.child,
    this.widthFactor,
    this.heightFactor,
    this.padding,
  }) : super(key: key);

  final Widget child;
  final double widthFactor;
  final double heightFactor;
  final EdgeInsets padding;

  @override
  Widget build(BuildContext context) {
    Widget result = Align(
      alignment: AlignmentDirectional.topCenter,
      widthFactor: widthFactor,
      heightFactor: heightFactor,
      child: child,
    );

    if (padding != null) {
      result = Container(padding: padding, child: result);
    }
    return result;
  }
}

class Bottom extends StatelessWidget {
  const Bottom({
    Key key,
    @required this.child,
    this.widthFactor,
    this.heightFactor,
    this.padding,
  }) : super(key: key);

  final Widget child;
  final double widthFactor;
  final double heightFactor;
  final EdgeInsets padding;

  @override
  Widget build(BuildContext context) {
    Widget result = Align(
      alignment: AlignmentDirectional.bottomCenter,
      widthFactor: widthFactor,
      heightFactor: heightFactor,
      child: child,
    );

    if (padding != null) {
      result = Container(padding: padding, child: result);
    }
    return result;
  }
}
