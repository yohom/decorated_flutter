import 'package:flutter/cupertino.dart';

@Deprecated('使用AlignStart代替')
typedef Start = AlignStart;

class AlignStart extends StatelessWidget {
  const AlignStart({
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

@Deprecated('使用AlignLeft代替')
typedef Left = AlignLeft;

class AlignLeft extends StatelessWidget {
  const AlignLeft({
    super.key,
    required this.child,
    this.widthFactor,
    this.heightFactor,
    this.padding,
    this.width,
    this.height,
  });

  final Widget child;
  final double? widthFactor, heightFactor, width, height;
  final EdgeInsets? padding;

  @override
  Widget build(BuildContext context) {
    Widget result = Align(
      alignment: Alignment.centerLeft,
      widthFactor: widthFactor,
      heightFactor: heightFactor,
      child: child,
    );

    if (padding != null || width != null || height != null) {
      result = Container(
        width: width,
        height: height,
        padding: padding,
        child: result,
      );
    }
    return result;
  }
}

@Deprecated('使用AlignEnd代替')
typedef End = AlignEnd;

class AlignEnd extends StatelessWidget {
  const AlignEnd({
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

@Deprecated('使用AlignRight代替')
typedef Right = AlignRight;

class AlignRight extends StatelessWidget {
  const AlignRight({
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

@Deprecated('使用AlignTop代替')
typedef Top = AlignTop;

class AlignTop extends StatelessWidget {
  const AlignTop({
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

@Deprecated('使用AlignBottom代替')
typedef Bottom = AlignBottom;

class AlignBottom extends StatelessWidget {
  const AlignBottom({
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
