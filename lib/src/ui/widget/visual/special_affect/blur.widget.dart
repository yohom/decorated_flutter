import 'dart:ui' as ui;

import 'package:flutter/material.dart';

class Blur extends StatelessWidget {
  const Blur({
    Key key,
    this.background,
    @required this.child,
    this.alignment = AlignmentDirectional.center,
    this.sigmaX = 2,
    this.sigmaY = 2,
    this.fit = StackFit.expand,
  }) : super(key: key);

  final Widget background;
  final Widget child;
  final AlignmentGeometry alignment;
  final double sigmaX;
  final double sigmaY;
  final StackFit fit;

  @override
  Widget build(BuildContext context) {
    Widget result = BackdropFilter(
      filter: ui.ImageFilter.blur(
        sigmaX: sigmaX,
        sigmaY: sigmaY,
      ),
      child: child,
    );

    if (background != null) {
      result = Stack(
        alignment: alignment,
        fit: fit,
        children: <Widget>[background, result],
      );
    }
    return result;
  }
}
