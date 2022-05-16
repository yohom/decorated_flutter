import 'package:flutter/cupertino.dart';

typedef AlignStart = Start;

@Deprecated('使用AlignStart代替')
class Start extends StatelessWidget {
  const Start({
    super.key,
    required this.child,
    this.widthFactor,
    this.heightFactor,
    this.padding,
  });

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

typedef AlignLeft = Left;

@Deprecated('使用AlignLeft代替')
class Left extends StatelessWidget {
  const Left({
    super.key,
    required this.child,
    this.widthFactor,
    this.heightFactor,
    this.padding,
  });

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

typedef AlignEnd = End;

@Deprecated('使用AlignEnd代替')
class End extends StatelessWidget {
  const End({
    super.key,
    required this.child,
    this.widthFactor,
    this.heightFactor,
    this.padding,
  });

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

typedef AlignRight = Right;

@Deprecated('使用AlignRight代替')
class Right extends StatelessWidget {
  const Right({
    super.key,
    required this.child,
    this.widthFactor,
    this.heightFactor,
    this.padding,
  });

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

typedef AlignTop = Top;

@Deprecated('使用AlignTop代替')
class Top extends StatelessWidget {
  const Top({
    super.key,
    required this.child,
    this.widthFactor,
    this.heightFactor,
    this.padding,
    this.margin,
  });

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

typedef AlignBottom = Bottom;

@Deprecated('使用AlignBottom代替')
class Bottom extends StatelessWidget {
  const Bottom({
    super.key,
    required this.child,
    this.widthFactor,
    this.heightFactor,
    this.padding,
  });

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
