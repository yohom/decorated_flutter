import 'package:flutter/material.dart';
import 'package:rxdart/rxdart.dart';

class ShowUpTransition extends StatefulWidget {
  final int delay;
  final int duration;
  final Widget child;

  ShowUpTransition({
    Key key,
    this.delay = 500,
    this.duration = 700,
    this.child,
  }) : super(key: key);

  @override
  _ShowUpTransitionState createState() {
    return _ShowUpTransitionState();
  }
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

    Observable.just('')
        .delay(Duration(milliseconds: widget.delay))
        .listen((_) => _controller.forward());
  }

  @override
  Widget build(BuildContext context) {
    return ScaleTransition(
      scale: _animation,
      child: widget.child,
    );
  }

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }
}
