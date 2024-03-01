import 'package:decorated_flutter/decorated_flutter.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';

// 兼容旧版命名
typedef AnimatedScaleButton = SpringContainer;

/// 带有缩放动画的按钮
///
/// 当按下时, 会缩放至0.9倍, 松开恢复到原状, 有些类似AppStore点击卡片时的动画
class SpringContainer extends StatefulWidget {
  const SpringContainer({
    super.key,
    required this.child,
    required this.onPressed,
    this.minScale = 0.9,
  });

  final Widget child;
  final ContextCallback onPressed;
  final double minScale;

  @override
  _SpringContainerState createState() => _SpringContainerState();
}

class _SpringContainerState extends State<SpringContainer> {
  late bool _pressed;

  @override
  void initState() {
    super.initState();
    _pressed = false;
  }

  @override
  Widget build(BuildContext context) {
    const duration = Duration(milliseconds: 100);
    return TweenAnimationBuilder<double>(
      duration: duration,
      curve: Curves.easeOut,
      builder: (BuildContext context, value, Widget? child) {
        return Transform.scale(
          scale: value,
          alignment: AlignmentDirectional.center,
          child: child,
        );
      },
      tween: Tween(begin: 1, end: _pressed ? widget.minScale : 1),
      child: MouseRegion(
        cursor: SystemMouseCursors.click,
        child: GestureDetector(
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
          onTapDown: (_) {
            setState(() {
              _pressed = true;
            });
          },
          onTapUp: (_) {
            if (_pressed == true) {
              Future.delayed(duration, () {
                setStateSafely(() {
                  _pressed = false;
                });
              });
            }

            widget.onPressed(context);
          },
          onTapCancel: () {
            setState(() {
              _pressed = false;
            });
          },
          child: widget.child,
        ),
      ),
    );
  }
}

/// 带加载中动画的按钮
///
/// 其中回调是返回Future的函数, 按钮会在回调执行完毕后, 恢复到原状
@Deprecated('感觉不好用')
class LoadingElevatedButton extends StatefulWidget {
  const LoadingElevatedButton({
    super.key,
    this.loadingChild = const CupertinoActivityIndicator(),
    required this.child,
    this.errorChild,
    required this.onPressed,
    this.style,
  });

  final Widget child;
  final Widget? loadingChild, errorChild;
  final ButtonStyle? style;
  final Future<void> Function() onPressed;

  @override
  State<LoadingElevatedButton> createState() => _LoadingElevatedButtonState();
}

class _LoadingElevatedButtonState extends State<LoadingElevatedButton> {
  late bool _isLoading;
  late bool _isError;

  @override
  void initState() {
    super.initState();
    _isLoading = false;
    _isError = false;
  }

  @override
  Widget build(BuildContext context) {
    return ElevatedButton(
      style: widget.style,
      onPressed: () {
        setState(() => _isLoading = true);
        widget
            .onPressed()
            .catchError((_) => setState(() => _isError = true))
            .whenComplete(() => setState(() => _isLoading = false));
      },
      child: _isError && widget.errorChild != null
          ? widget.errorChild!
          : _isLoading
              ? widget.loadingChild
              : widget.child,
    );
  }
}
