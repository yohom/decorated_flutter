import 'package:flutter/material.dart';

class ParallaxBox extends StatefulWidget {
  const ParallaxBox({
    Key key,
    this.background,
    this.foreground,
    this.overlay,
    this.alignment = AlignmentDirectional.topCenter,
    this.fit = StackFit.loose,
    this.overflow = Overflow.clip,
    this.parallaxRate = 0.2,
  })  : assert(parallaxRate > 0.0),
        super(key: key);

  /// 背景
  final Widget background;

  /// 前景
  final Widget foreground;

  /// overlay, 建议使用[Position]来控制布局
  final Widget overlay;

  /// 内部[Stack]的[alignment]
  final AlignmentDirectional alignment;

  /// 内部[Stack]的[fit]
  final StackFit fit;

  /// 内部[Stack]的[overflow]
  final Overflow overflow;

  /// 视差率, 也就是前景移动时, 背景移动的速率
  final double parallaxRate;

  @override
  _ParallaxBoxState createState() => _ParallaxBoxState();
}

class _ParallaxBoxState extends State<ParallaxBox> {
  final _controller = ScrollController();

  double _parallaxOffset = 0.0;

  @override
  void initState() {
    super.initState();
    _controller.addListener(() {
      setState(() {
        return _parallaxOffset = -_controller.offset * widget.parallaxRate;
      });
    });
  }

  @override
  Widget build(BuildContext context) {
    return Stack(
      alignment: widget.alignment,
      fit: widget.fit,
      children: <Widget>[
        Transform.translate(
          offset: Offset(0.0, _parallaxOffset),
          child: widget.background,
        ),
        SingleChildScrollView(
          controller: _controller,
          child: widget.foreground,
        ),
        widget.overlay,
      ],
    );
  }

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }
}
