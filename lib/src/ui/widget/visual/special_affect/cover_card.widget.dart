import 'package:decorated_flutter/decorated_flutter.dart';
import 'package:flutter/material.dart';

class CoverCard extends StatefulWidget {
  const CoverCard({
    Key? key,
    this.background,
    this.foreground,
    this.overlay = const SizedBox.shrink(),
    this.alignment = AlignmentDirectional.topCenter,
    this.fit = StackFit.loose,
    this.parallaxRate = 0.2,
    required this.cover,
    required this.card,
    required this.coverHeight,
  })  : assert(parallaxRate > 0.0),
        super(key: key);

  /// 背景
  final Widget? background;

  /// 前景
  final Widget? foreground;

  /// overlay, 建议使用[Position]来控制布局
  final Widget overlay;

  /// 内部[Stack]的[alignment]
  final AlignmentDirectional alignment;

  /// 内部[Stack]的[fit]
  final StackFit fit;

  /// 视差率, 也就是前景移动时, 背景移动的速率
  final double parallaxRate;

  /// 封面
  final Widget cover;

  /// 内容Card
  final Widget card;

  /// 封面高度
  final double coverHeight;

  @override
  _CoverCardState createState() => _CoverCardState();
}

class _CoverCardState extends State<CoverCard> {
  final _controller = ScrollController();

  double _parallaxOffset = 0.0;

  @override
  void initState() {
    super.initState();
    _controller.addListener(() {
      setState(() {
        _parallaxOffset = -_controller.offset * widget.parallaxRate;
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
          child: SizedBox(
            height: widget.coverHeight,
            child: widget.cover,
          ),
        ),
        SingleChildScrollView(
          controller: _controller,
          child: FractionalScreen(
            heightFactor: 1,
            children: <Widget>[
              Container(height: widget.coverHeight),
              widget.card,
            ],
          ),
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
