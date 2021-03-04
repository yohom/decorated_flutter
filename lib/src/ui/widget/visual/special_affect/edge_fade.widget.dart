// @dart=2.9

import 'package:flutter/material.dart';

class EdgeFade extends StatelessWidget {
  const EdgeFade({
    Key key,
    this.stops,
    this.begin,
    this.end,
    @required this.child,
  }) : super(key: key);

  final List<double> stops;
  final AlignmentGeometry begin;
  final AlignmentGeometry end;
  final Widget child;

  @override
  Widget build(BuildContext context) {
    return ShaderMask(
      child: child,
      shaderCallback: (rect) {
        return LinearGradient(
          begin: begin ?? Alignment.centerLeft,
          end: end ?? Alignment.centerRight,
          stops: stops ?? [0.9, 1.0],
          colors: [Colors.black, Colors.transparent],
        ).createShader(rect);
      },
      blendMode: BlendMode.dstIn,
    );
  }
}
