import 'dart:ui';

import 'package:flutter/widgets.dart';

class AnimatedShaderMask extends ImplicitlyAnimatedWidget {
  const AnimatedShaderMask({
    super.key,
    required this.child,
    required this.gradient,
    this.blendMode = BlendMode.dstIn,
    super.curve = Curves.linear,
    super.duration = const Duration(milliseconds: 300),
    super.onEnd,
  });

  final Widget child;
  final Gradient gradient;
  final BlendMode blendMode;

  @override
  AnimatedWidgetBaseState<AnimatedShaderMask> createState() =>
      _AnimatedShaderMaskState();
}

class _AnimatedShaderMaskState
    extends AnimatedWidgetBaseState<AnimatedShaderMask> {
  _GradientTween? _gradientTween;

  @override
  void forEachTween(TweenVisitor<dynamic> visitor) {
    _gradientTween = visitor(
      _gradientTween,
      widget.gradient,
      (value) => _GradientTween(begin: value as Gradient),
    ) as _GradientTween?;
  }

  @override
  Widget build(BuildContext context) {
    return ShaderMask(
      blendMode: widget.blendMode,
      shaderCallback: (Rect bounds) {
        final gradient = _gradientTween!.evaluate(animation);
        return gradient.createShader(bounds);
      },
      child: widget.child,
    );
  }
}

class _GradientTween extends Tween<Gradient> {
  _GradientTween({super.begin, Gradient? end}) : super(end: end ?? begin);

  @override
  Gradient lerp(double t) {
    if (begin is LinearGradient && end is LinearGradient) {
      final b = begin as LinearGradient;
      final e = end as LinearGradient;
      return LinearGradient(
        begin: AlignmentGeometry.lerp(b.begin, e.begin, t)!,
        end: AlignmentGeometry.lerp(b.end, e.end, t)!,
        colors: List.generate(
          b.colors.length,
          (i) => Color.lerp(b.colors[i], e.colors[i], t)!,
        ),
        stops: List.generate(
          b.stops!.length,
          (i) => lerpDouble(b.stops![i], e.stops![i], t)!,
        ),
      );
    }
    // fallback: 只返回end
    return end!;
  }
}
