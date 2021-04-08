import 'package:decorated_flutter/decorated_flutter.dart';
import 'package:flutter/material.dart';

class ShowUpTransition extends StatefulWidget {
  ShowUpTransition({
    Key key,
    this.delay = Duration.zero,
    this.duration = const Duration(milliseconds: 700),
    this.safeArea = false,
    this.child,
  }) : super(key: key);

  final Duration delay;
  final Duration duration;
  final bool safeArea;
  final Widget child;

  @override
  _ShowUpTransitionState createState() => _ShowUpTransitionState();
}

class _ShowUpTransitionState extends State<ShowUpTransition>
    with SingleTickerProviderStateMixin, AnimationMixin {
  @override
  Duration get duration => widget.duration;

  @override
  Curve get curve => Curves.elasticOut;

  @override
  void initState() {
    super.initState();
    Future.delayed(widget.delay, () => 0).then((_) {
      if (!animationDisposed) animationController.forward();
    });
  }

  @override
  Widget build(BuildContext context) {
    Widget result = ScaleTransition(scale: animation, child: widget.child);

    if (widget.safeArea) {
      result = SafeArea(child: result);
    }
    return result;
  }
}
