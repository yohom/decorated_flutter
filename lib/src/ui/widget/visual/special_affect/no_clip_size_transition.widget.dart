import 'dart:math' as math;

import 'package:flutter/material.dart';

/// 内置的SizeTransition会带有ClipRect, 导致阴影被切, 这里去掉相关逻辑
class NoClipSizeTransition extends AnimatedWidget {
  const NoClipSizeTransition({
    super.key,
    required Animation<double> sizeFactor,
    this.fixedCrossAxisSizeFactor,
    this.child,
  })  : assert(fixedCrossAxisSizeFactor == null ||
            fixedCrossAxisSizeFactor >= 0.0),
        super(listenable: sizeFactor);

  Animation<double> get sizeFactor => listenable as Animation<double>;

  final double? fixedCrossAxisSizeFactor;

  final Widget? child;

  @override
  Widget build(BuildContext context) {
    return Align(
      alignment: AlignmentDirectional(-1.0, 0),
      heightFactor: math.max(sizeFactor.value, 0.0),
      widthFactor: math.max(sizeFactor.value, 0.0),
      child: child,
    );
  }
}
