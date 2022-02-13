import 'package:flutter/cupertino.dart';

class Start extends StatelessWidget {
  const Start({
    Key? key,
    required this.child,
    this.widthFactor,
    this.heightFactor,
    this.padding,
  }) : super(key: key);

  final Widget child;
  final double? widthFactor;
  final double? heightFactor;
  final EdgeInsets? padding;

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

class Left extends StatelessWidget {
  const Left({
    Key? key,
    required this.child,
    this.widthFactor,
    this.heightFactor,
    this.padding,
  }) : super(key: key);

  final Widget child;
  final double? widthFactor;
  final double? heightFactor;
  final EdgeInsets? padding;

  @override
  Widget build(BuildContext context) {
    Widget result = Align(
      alignment: Alignment.centerLeft,
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
    Key? key,
    required this.child,
    this.widthFactor,
    this.heightFactor,
    this.padding,
  }) : super(key: key);

  final Widget child;
  final double? widthFactor;
  final double? heightFactor;
  final EdgeInsets? padding;

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

class Right extends StatelessWidget {
  const Right({
    Key? key,
    required this.child,
    this.widthFactor,
    this.heightFactor,
    this.padding,
  }) : super(key: key);

  final Widget child;
  final double? widthFactor;
  final double? heightFactor;
  final EdgeInsets? padding;

  @override
  Widget build(BuildContext context) {
    Widget result = Align(
      alignment: Alignment.centerRight,
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
    Key? key,
    required this.child,
    this.widthFactor,
    this.heightFactor,
    this.padding,
    this.margin,
  }) : super(key: key);

  final Widget child;
  final double? widthFactor;
  final double? heightFactor;
  final EdgeInsets? padding;
  final EdgeInsets? margin;

  @override
  Widget build(BuildContext context) {
    Widget result = Align(
      alignment: AlignmentDirectional.topCenter,
      widthFactor: widthFactor,
      heightFactor: heightFactor,
      child: child,
    );

    if (padding != null || margin != null) {
      result = Container(padding: padding, margin: margin, child: result);
    }
    return result;
  }
}

class Bottom extends StatelessWidget {
  const Bottom({
    Key? key,
    required this.child,
    this.widthFactor,
    this.heightFactor,
    this.padding,
  }) : super(key: key);

  final Widget child;
  final double? widthFactor;
  final double? heightFactor;
  final EdgeInsets? padding;

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
