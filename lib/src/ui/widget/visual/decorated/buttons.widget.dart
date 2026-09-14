import 'package:decorated_flutter/decorated_flutter.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/gestures.dart';
import 'package:flutter/material.dart';
import 'package:flutter/physics.dart';

// 兼容旧版命名
typedef AnimatedScaleButton = SpringContainer;

/// 带有缩放动画的按钮
///
/// 当按下时, 会缩放至0.95倍, 松开后使用弹簧动画恢复到原状, 有些类似AppStore点击卡片时的动画
class SpringContainer extends StatefulWidget {
  const SpringContainer({
    super.key,
    required this.child,
    required this.onPressed,
    this.minScale = 0.95,
    this.debounceDuration = const Duration(milliseconds: 800),
  });

  final Widget child;
  final ContextCallback onPressed;
  final double minScale;
  final Duration debounceDuration;

  @override
  _SpringContainerState createState() => _SpringContainerState();
}

class _SpringContainerState extends State<SpringContainer>
    with SingleTickerProviderStateMixin {
  static final _spring = SpringDescription.withDampingRatio(
    mass: 1,
    stiffness: 500,
    ratio: 1,
  );

  final _interactionKey = GlobalKey();
  late final AnimationController _scaleController;
  var _pressed = false;
  var _isProcessing = false;
  var _isInside = false;

  @override
  void initState() {
    super.initState();
    _scaleController = AnimationController.unbounded(
      vsync: this,
      value: 1,
    );
  }

  @override
  void didUpdateWidget(covariant SpringContainer oldWidget) {
    super.didUpdateWidget(oldWidget);
    if (_pressed && oldWidget.minScale != widget.minScale) {
      _animateTo(widget.minScale);
    }
  }

  @override
  void dispose() {
    _scaleController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Semantics(
      button: true,
      onTap: () {
        _setPressed(false);
        _handlePress(context);
      },
      child: AnimatedBuilder(
        animation: _scaleController,
        builder: (BuildContext context, Widget? child) {
          return Transform.scale(
            scale: _scaleController.value,
            alignment: AlignmentDirectional.center,
            child: child,
          );
        },
        child: MouseRegion(
          cursor: SystemMouseCursors.click,
          child: RawGestureDetector(
            key: _interactionKey,
            behavior: HitTestBehavior.opaque,
            gestures: <Type, GestureRecognizerFactory>{
              _PressGestureRecognizer:
                  GestureRecognizerFactoryWithHandlers<_PressGestureRecognizer>(
                () => _PressGestureRecognizer(debugOwner: this),
                (_PressGestureRecognizer instance) {
                  instance
                    ..onPressStart = _handlePressStart
                    ..onPressMove = _handlePressMove
                    ..onPressEnd = _handlePressEnd
                    ..onPressCancel = _handlePressCancel;
                },
              ),
            },
            excludeFromSemantics: true,
            child: widget.child,
          ),
        ),
      ),
    );
  }

  void _handlePressStart() {
    _isInside = true;
    _setPressed(true);
  }

  void _handlePressMove(Offset localPosition) {
    _isInside = _contains(localPosition);
    _setPressed(_isInside);
  }

  void _handlePressEnd(Offset localPosition) {
    _isInside = _contains(localPosition);
    final shouldPress = _isInside;
    _setPressed(false);
    if (shouldPress) {
      _handlePress(context);
    }
  }

  void _handlePressCancel() {
    _isInside = false;
    _setPressed(false);
  }

  bool _contains(Offset localPosition) {
    final renderObject = _interactionKey.currentContext?.findRenderObject();
    if (renderObject is! RenderBox || !renderObject.hasSize) return false;
    return (Offset.zero & renderObject.size).contains(localPosition);
  }

  void _setPressed(bool pressed) {
    if (_pressed == pressed) return;
    _pressed = pressed;
    _animateTo(pressed ? widget.minScale : 1);
  }

  void _animateTo(double target) {
    _scaleController.animateWith(
      SpringSimulation(
        _spring,
        _scaleController.value,
        target,
        _scaleController.velocity,
        snapToEnd: true,
      ),
    );
  }

  void _handlePress(BuildContext context) {
    if (_isProcessing) return;

    _isProcessing = true;
    widget.onPressed(context);
    Future.delayed(widget.debounceDuration, () {
      if (mounted) {
        setState(() => _isProcessing = false);
      }
    });
  }
}

class _PressGestureRecognizer extends OneSequenceGestureRecognizer {
  _PressGestureRecognizer({super.debugOwner});

  VoidCallback? onPressStart;
  ValueChanged<Offset>? onPressMove;
  ValueChanged<Offset>? onPressEnd;
  VoidCallback? onPressCancel;

  int? _pointer;

  @override
  void addAllowedPointer(PointerDownEvent event) {
    if (_pointer != null) return;
    _pointer = event.pointer;
    startTrackingPointer(event.pointer, event.transform);
    onPressStart?.call();
  }

  @override
  void handleEvent(PointerEvent event) {
    if (event.pointer != _pointer) return;

    if (event is PointerMoveEvent) {
      onPressMove?.call(event.localPosition);
    } else if (event is PointerUpEvent) {
      resolve(GestureDisposition.accepted);
      stopTrackingPointer(event.pointer);
      _pointer = null;
      onPressEnd?.call(event.localPosition);
    } else if (event is PointerCancelEvent) {
      stopTrackingPointer(event.pointer);
      _pointer = null;
      onPressCancel?.call();
      resolve(GestureDisposition.rejected);
    }
  }

  @override
  void rejectGesture(int pointer) {
    if (_pointer == pointer) {
      _pointer = null;
      onPressCancel?.call();
    }
    super.rejectGesture(pointer);
  }

  @override
  void didStopTrackingLastPointer(int pointer) {}

  @override
  String get debugDescription => 'press';
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
