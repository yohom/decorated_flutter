import 'dart:ui' as ui;

import 'package:flutter/material.dart';

class Blur extends StatelessWidget {
  const Blur({
    Key key,
    @required this.background,
    @required this.foreground,
    this.alignment = AlignmentDirectional.center,
    this.sigmaX = 0,
    this.sigmaY = 0,
  }) : super(key: key);

  final Widget background;
  final Widget foreground;
  final AlignmentGeometry alignment;
  final double sigmaX;
  final double sigmaY;

  @override
  Widget build(BuildContext context) {
    return Stack(
      alignment: alignment,
      children: <Widget>[
        background,
        ClipRect(
          child: BackdropFilter(
            filter: ui.ImageFilter.blur(
              sigmaX: sigmaX,
              sigmaY: sigmaY,
            ),
            child: foreground,
          ),
        )
      ],
    );
  }
}
