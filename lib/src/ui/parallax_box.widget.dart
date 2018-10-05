import 'package:flutter/material.dart';

class ParallaxBox extends StatefulWidget {
  const ParallaxBox({
    Key key,
    this.background,
    this.foreground,
    this.parallaxRate = 0.2,
  })  : assert(parallaxRate > 0.0),
        super(key: key);

  /// 背景
  final Widget background;

  /// 前景
  final Widget foreground;

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
      children: <Widget>[
        Transform.translate(
          offset: Offset(0.0, _parallaxOffset),
          child: widget.background,
        ),
        SingleChildScrollView(
          controller: _controller,
          child: widget.foreground,
        ),
      ],
    );
  }

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }
}
