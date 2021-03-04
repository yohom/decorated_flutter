// @dart=2.9

import 'dart:ui' as ui;

import 'package:flutter/material.dart';

/// 模糊子widget
class Blur extends StatelessWidget {
  const Blur({
    Key key,
    this.applyInsets = false,
    this.sigmaX = 2,
    this.sigmaY = 2,
    this.constraints,
    @required this.child,
  }) : super(key: key);

  final bool applyInsets;
  final double sigmaX;
  final double sigmaY;
  final BoxConstraints constraints;
  final Widget child;

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: applyInsets
          ? EdgeInsets.symmetric(horizontal: sigmaX * 3, vertical: sigmaY * 3)
          : EdgeInsets.zero,
      constraints: constraints ?? BoxConstraints.expand(),
      child: ImageFiltered(
        imageFilter: ui.ImageFilter.blur(sigmaX: sigmaX, sigmaY: sigmaY),
        child: child,
      ),
    );
  }
}

/// 背景模糊
class BackgroundBlur extends StatelessWidget {
  const BackgroundBlur({
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
