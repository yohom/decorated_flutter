import 'package:flutter/material.dart';
import 'package:rxdart/rxdart.dart';

typedef Widget _Builder(BuildContext context, AnimationController controller);

enum SlideDirection {
  vertical,
  horizontal,
}

class FadeSlideTransition extends StatefulWidget {
  /// [builder]有两个参数, 一个是[BuildContext], 就是常规用法, 另一个是[_controller], 是
  /// 为了在[builder]方法体中能够控制动画, 比如说进行动画的reverse.
  final _Builder builder;

  /// 初始的偏移量, 为了让child在动画之后位移到原来的位置, 而不是位移到别处去, 导致隐患.
  final Offset originOffset;

  /// 延迟多久开始动画
  final Duration delay;

  /// 动画持续多久
  final Duration duration;

  /// 淡入淡出的curve
  final Curve fadeCurve;

  /// 滑动的curve
  final Curve slideCurve;

  /// 逆向的滑动curve
  final Curve slideReverseCurve;

  /// 滑动的方向
  final SlideDirection direction;

  /// 是否立即执行动画
  final bool immediately;

  FadeSlideTransition({
    Key key,
    this.originOffset = const Offset(0.0, 30.0),
    this.delay = const Duration(milliseconds: 0),
    this.duration = const Duration(milliseconds: 700),
    this.fadeCurve = Curves.easeOut,
    this.slideCurve = Curves.easeOut,
    this.slideReverseCurve = Curves.easeIn,
    this.direction = SlideDirection.vertical,
    this.immediately = true,
    this.builder,
  }) : super(key: key);

  @override
  _FadeInSlideTransitionState createState() => _FadeInSlideTransitionState();
}

class _FadeInSlideTransitionState extends State<FadeSlideTransition>
    with SingleTickerProviderStateMixin {
  AnimationController _controller;
  Animation<double> _slideAnimation;
  Animation<double> _fadeAnimation;

  @override
  void initState() {
    _controller = AnimationController(
      vsync: this,
      duration: widget.duration,
    );

    _slideAnimation = CurvedAnimation(
      parent: _controller,
      curve: widget.slideCurve,
      reverseCurve: widget.slideReverseCurve,
    );

    _fadeAnimation = CurvedAnimation(
      parent: _controller,
      curve: widget.fadeCurve,
    );

    if (widget.immediately) {
      Stream.value('').delay(widget.delay).listen((_) => _controller.forward());
    }

    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Transform.translate(
      offset: widget.originOffset,
      child: AnimatedBuilder(
        animation: _controller,
        child: widget.builder(context, _controller),
        builder: (context, child) {
          return Transform.translate(
            offset: Offset(
              widget.direction == SlideDirection.horizontal
                  ? -_slideAnimation.value * widget.originOffset.dx
                  : 0.0,
              widget.direction == SlideDirection.vertical
                  ? -_slideAnimation.value * widget.originOffset.dy
                  : 0.0,
            ),
            child: Opacity(opacity: _fadeAnimation.value, child: child),
          );
        },
      ),
    );
  }

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }
}
