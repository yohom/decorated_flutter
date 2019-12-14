import 'package:flutter/material.dart';
import 'package:rxdart/rxdart.dart';

class ShowUpTransition extends StatefulWidget {
  ShowUpTransition({
    Key key,
    this.delay = 500,
    this.duration = 700,
    this.safeArea = false,
    this.child,
  }) : super(key: key);

  final int delay;
  final int duration;
  final bool safeArea;
  final Widget child;

  @override
  _ShowUpTransitionState createState() => _ShowUpTransitionState();
}

class _ShowUpTransitionState extends State<ShowUpTransition>
    with TickerProviderStateMixin {
  AnimationController _controller;
  Animation<double> _animation;

  @override
  void initState() {
    super.initState();
    _controller = AnimationController(
      duration: Duration(milliseconds: widget.duration),
      vsync: this,
    );
    _animation = CurvedAnimation(parent: _controller, curve: Curves.elasticOut);

    Stream.value('')
        .delay(Duration(milliseconds: widget.delay))
        .listen((_) => _controller.forward());
  }

  @override
  Widget build(BuildContext context) {
    Widget result = ScaleTransition(
      scale: _animation,
      child: widget.child,
    );

    if (widget.safeArea) {
      result = SafeArea(child: result);
    }
    return result;
  }

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }
}
