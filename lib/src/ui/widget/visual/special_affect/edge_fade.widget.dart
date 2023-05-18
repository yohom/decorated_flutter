import 'package:flutter/material.dart';

class EdgeFade extends StatelessWidget {
  const EdgeFade({
    super.key,
    this.stops = const [0.9, 1.0],
    this.begin = Alignment.centerLeft,
    this.end = Alignment.centerRight,
    required this.child,
  });

  final List<double> stops;
  final AlignmentGeometry begin;
  final AlignmentGeometry end;
  final Widget child;

  @override
  Widget build(BuildContext context) {
    return ShaderMask(
      shaderCallback: (rect) {
        return LinearGradient(
          begin: begin,
          end: end,
          stops: stops,
          colors: const [Colors.black, Colors.transparent],
        ).createShader(rect);
      },
      blendMode: BlendMode.dstIn,
      child: child,
    );
  }
}
