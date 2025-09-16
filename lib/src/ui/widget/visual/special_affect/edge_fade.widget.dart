import 'package:flutter/material.dart';

import 'animated_shader_mask.widget.dart';

class EdgeFade extends StatelessWidget {
  const EdgeFade({
    super.key,
    this.stops = const [0.9, 1.0],
    this.begin = Alignment.centerLeft,
    this.end = Alignment.centerRight,
    required this.child,
  }) : assert(stops.length == 2 || stops.length == 4);

  const EdgeFade.vertical({
    super.key,
    this.stops = const [0.9, 1.0],
    required this.child,
  })  : begin = Alignment.topCenter,
        end = Alignment.bottomCenter,
        assert(stops.length == 2 || stops.length == 4);

  const EdgeFade.horizontal({
    super.key,
    this.stops = const [0.9, 1.0],
    required this.child,
  })  : begin = Alignment.centerLeft,
        end = Alignment.centerRight,
        assert(stops.length == 2 || stops.length == 4);

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
          colors: [
            if (stops.length == 4) ...[Colors.transparent, Colors.black],
            Colors.black,
            Colors.transparent,
          ],
        ).createShader(rect);
      },
      blendMode: BlendMode.dstIn,
      child: child,
    );
  }
}

class AnimatedEdgeFade extends StatelessWidget {
  const AnimatedEdgeFade({
    super.key,
    this.stops = const [0.9, 1.0],
    this.begin = Alignment.centerLeft,
    this.end = Alignment.centerRight,
    this.enabled = true,
    required this.child,
  }) : assert(stops.length == 2 || stops.length == 4);

  final List<double> stops;
  final AlignmentGeometry begin;
  final AlignmentGeometry end;
  final bool enabled;
  final Widget child;

  @override
  Widget build(BuildContext context) {
    return AnimatedShaderMask(
      gradient: LinearGradient(
        begin: begin,
        end: end,
        stops: stops,
        colors: enabled
            ? [
                if (stops.length == 4) ...[Colors.transparent, Colors.black],
                Colors.black,
                Colors.transparent,
              ]
            : List.filled(stops.length, Colors.black),
      ),
      blendMode: BlendMode.dstIn,
      child: child,
    );
  }
}
