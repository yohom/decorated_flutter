import 'package:flutter/material.dart';
import 'package:flutter/widgets.dart';

class DotTabIndicator extends Decoration {
  final double offset;
  final double dotRadius;
  final Color color;

  const DotTabIndicator({
    this.offset = 5 / 6,
    this.dotRadius = 2.0,
    this.color = Colors.black,
  });

  @override
  Decoration lerpFrom(Decoration a, double t) {
    if (a is DotTabIndicator) {
      return DotTabIndicator();
    }
    return super.lerpFrom(a, t);
  }

  @override
  Decoration lerpTo(Decoration b, double t) {
    if (b is DotTabIndicator) {
      return DotTabIndicator();
    }
    return super.lerpTo(b, t);
  }

  @override
  _DotPainter createBoxPainter([VoidCallback onChanged]) {
    return _DotPainter(this, onChanged);
  }
}

class _DotPainter extends BoxPainter {
  _DotPainter(this.decoration, VoidCallback onChanged)
      : assert(decoration != null),
        super(onChanged);

  final DotTabIndicator decoration;

  @override
  void paint(Canvas canvas, Offset offset, ImageConfiguration configuration) {
    assert(configuration != null);
    assert(configuration.size != null);

    final _rawOffset = (offset & configuration.size).bottomCenter;
    final _offset = Offset(_rawOffset.dx, _rawOffset.dy * decoration.offset);
    canvas.drawCircle(
      _offset,
      decoration.dotRadius,
      Paint()..color = decoration.color,
    );
  }
}
