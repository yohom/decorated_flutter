import 'package:decorated_flutter/src/utils/utils.export.dart';
import 'package:flutter/material.dart';

/// 带有缩放动画的按钮
///
/// 当按下时, 会缩放至0.9倍, 松开恢复到原状, 有些类似AppStore点击卡片时的动画
class AnimatedScaleButton extends StatefulWidget {
  const AnimatedScaleButton({
    super.key,
    required this.child,
    required this.onPressed,
    this.minScale = 0.9,
  });

  final Widget child;
  final ContextCallback onPressed;
  final double minScale;

  @override
  _AnimatedScaleButtonState createState() => _AnimatedScaleButtonState();
}

class _AnimatedScaleButtonState extends State<AnimatedScaleButton> {
  late bool _pressed;

  @override
  void initState() {
    super.initState();
    _pressed = false;
  }

  @override
  Widget build(BuildContext context) {
    return TweenAnimationBuilder<double>(
      duration: const Duration(milliseconds: 100),
      curve: Curves.easeOut,
      builder: (BuildContext context, value, Widget? child) {
        return Transform.scale(
          scale: value,
          alignment: AlignmentDirectional.center,
          child: child,
        );
      },
      tween: Tween(begin: 1, end: _pressed ? widget.minScale : 1),
      child: GestureDetector(
        onTapDown: (_) {
          setState(() {
            _pressed = true;
          });
        },
        onLongPress: () {
          setState(() {
            _pressed = true;
          });
        },
        onLongPressEnd: (_) {
          setState(() {
            _pressed = false;
          });
          widget.onPressed(context);
        },
        onTapUp: (_) {
          setState(() {
            _pressed = false;
          });
        },
        onTapCancel: () {
          setState(() {
            _pressed = false;
          });
        },
        onTap: () {
          widget.onPressed(context);
        },
        child: widget.child,
      ),
    );
  }
}
