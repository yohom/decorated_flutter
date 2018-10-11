import 'package:flutter/material.dart';

class Carousel extends StatefulWidget {
  final IndexedWidgetBuilder itemBuilder;
  final int itemCount;
  final double viewportFraction;

  const Carousel.builder({
    Key key,
    @required this.itemCount,
    @required this.itemBuilder,
    this.viewportFraction = 1.0,
  }) : super(key: key);

  @override
  _CarouselState createState() => _CarouselState();
}

class _CarouselState extends State<Carousel> {
  PageController _controller;

  @override
  initState() {
    super.initState();
    _controller = PageController(
      initialPage: 0,
      viewportFraction: widget.viewportFraction,
    );
  }

  @override
  Widget build(BuildContext context) {
    return PageView.builder(
      controller: _controller,
      itemCount: widget.itemCount,
      itemBuilder: (context, index) {
        return AnimatedBuilder(
          animation: _controller,
          builder: (context, child) {
            double value = 1.0;
            if (_controller.position.haveDimensions) {
              value = _controller.page - index;
              value = (1 - (value.abs() * .5)).clamp(0.5, 1.0) as double;
            } else if (index == 1) {
              // 如果是首次加载, 由于haveDimensions为false, 会导致index为1处的item
              // 的value也会是1, 这里手动调整一下value.
              value = 0.5;
            }

            return Transform.scale(
              scale: Curves.easeOut.transform(value),
              child: child,
            );
          },
          child: widget.itemBuilder(context, index),
        );
      },
    );
  }

  @override
  dispose() {
    _controller.dispose();
    super.dispose();
  }
}
