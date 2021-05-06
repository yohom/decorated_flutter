import 'package:flutter/material.dart';

class AnimatedScaleButton extends StatefulWidget {
  ///The widget that is to be displayed on your regular UI.
  final Widget child;

  ///Set this to true if your [child] doesn't change at runtime.
  final bool useCache;

  ///Use this value to determine the alignment of the animation.
  final Alignment alignment;

  ///Use this value to determine the scaling factor while the animation is being played. Choose a value between 0.0 and 1.0.
  final double minScale;

  ///Use this value to determine the duration of the animation.
  final int duration;

  ///Delegate for gesture callback.
  final GestureTapDownCallback? onTapDown;

  ///Delegate for gesture callback.
  final GestureTapUpCallback? onTapUp;

  ///Delegate for gesture callback.
  final GestureTapCallback? onTap;

  ///Delegate for gesture callback.
  final GestureTapCancelCallback? onTapCancel;

  ///Delegate for gesture callback.
  final GestureTapDownCallback? onSecondaryTapDown;

  ///Delegate for gesture callback.
  final GestureTapUpCallback? onSecondaryTapUp;

  ///Delegate for gesture callback.
  final GestureTapCancelCallback? onSecondaryTapCancel;

  ///Delegate for gesture callback.
  final GestureTapCallback? onDoubleTap;

  ///Delegate for gesture callback.
  final GestureLongPressCallback? onLongPress;

  ///Delegate for gesture callback.
  final GestureLongPressStartCallback? onLongPressStart;

  ///Delegate for gesture callback.
  final GestureLongPressMoveUpdateCallback? onLongPressMoveUpdate;

  ///Delegate for gesture callback.
  final GestureLongPressUpCallback? onLongPressUp;

  ///Delegate for gesture callback.
  final GestureLongPressEndCallback? onLongPressEnd;

  ///Delegate for gesture callback.
  final GestureDragDownCallback? onVerticalDragDown;

  ///Delegate for gesture callback.
  final GestureDragStartCallback? onVerticalDragStart;

  ///Delegate for gesture callback.
  final GestureDragUpdateCallback? onVerticalDragUpdate;

  ///Delegate for gesture callback.
  final GestureDragEndCallback? onVerticalDragEnd;

  ///Delegate for gesture callback.
  final GestureDragCancelCallback? onVerticalDragCancel;

  ///Delegate for gesture callback.
  final GestureDragDownCallback? onHorizontalDragDown;

  ///Delegate for gesture callback.
  final GestureDragStartCallback? onHorizontalDragStart;

  ///Delegate for gesture callback.
  final GestureDragUpdateCallback? onHorizontalDragUpdate;

  ///Delegate for gesture callback.
  final GestureDragEndCallback? onHorizontalDragEnd;

  ///Delegate for gesture callback.
  final GestureDragCancelCallback? onHorizontalDragCancel;

  ///Delegate for gesture callback.
  final GestureDragDownCallback? onPanDown;

  ///Delegate for gesture callback.
  final GestureDragStartCallback? onPanStart;

  ///Delegate for gesture callback.
  final GestureDragUpdateCallback? onPanUpdate;

  ///Delegate for gesture callback.
  final GestureDragEndCallback? onPanEnd;

  ///Delegate for gesture callback.
  final GestureDragCancelCallback? onPanCancel;

  ///Delegate for gesture callback.
  final GestureScaleStartCallback? onScaleStart;

  ///Delegate for gesture callback.
  final GestureScaleUpdateCallback? onScaleUpdate;

  ///Delegate for gesture callback.
  final GestureScaleEndCallback? onScaleEnd;

  ///Delegate for gesture callback.
  final GestureForcePressStartCallback? onForcePressStart;

  ///Delegate for gesture callback.
  final GestureForcePressPeakCallback? onForcePressPeak;

  ///Delegate for gesture callback.
  final GestureForcePressUpdateCallback? onForcePressUpdate;

  ///Delegate for gesture callback.
  final GestureForcePressEndCallback? onForcePressEnd;

  const AnimatedScaleButton({
    Key? key,
    this.useCache = true,
    this.alignment = Alignment.center,
    this.minScale = 0.9,
    this.duration = 100,
    this.onTapDown,
    this.onTapUp,
    this.onTap,
    this.onTapCancel,
    this.onSecondaryTapDown,
    this.onSecondaryTapUp,
    this.onSecondaryTapCancel,
    this.onDoubleTap,
    this.onLongPress,
    this.onLongPressStart,
    this.onLongPressMoveUpdate,
    this.onLongPressUp,
    this.onLongPressEnd,
    this.onVerticalDragDown,
    this.onVerticalDragStart,
    this.onVerticalDragUpdate,
    this.onVerticalDragEnd,
    this.onVerticalDragCancel,
    this.onHorizontalDragDown,
    this.onHorizontalDragStart,
    this.onHorizontalDragUpdate,
    this.onHorizontalDragEnd,
    this.onHorizontalDragCancel,
    this.onForcePressStart,
    this.onForcePressPeak,
    this.onForcePressUpdate,
    this.onForcePressEnd,
    this.onPanDown,
    this.onPanStart,
    this.onPanUpdate,
    this.onPanEnd,
    this.onPanCancel,
    this.onScaleStart,
    this.onScaleUpdate,
    this.onScaleEnd,
    required this.child,
  })   : assert(minScale >= 0.0 && minScale <= 1.0),
        super(key: key);

  @override
  _AnimatedScaleButtonState createState() => _AnimatedScaleButtonState(
        useCache,
        alignment,
        minScale,
      );
}

class _AnimatedScaleButtonState extends State<AnimatedScaleButton>
    with SingleTickerProviderStateMixin {
  Widget? child;
  final bool useCache;
  final Alignment alignment;
  final double minScale;

  ///The [AnimationController] used to create the spring effect.
  late AnimationController _animationController;
  late Animation<double> animation;

  bool _isSpringDown = false;

  bool _isEnabled = true;

  ///Use this value to determine the depth of debug logging that is actually only here for myself and the Swiss scientists.
  final int _debugLevel = 0;

  _AnimatedScaleButtonState(this.useCache, this.alignment, this.minScale);

  @override
  void initState() {
    super.initState();

    if (useCache) child = wrapper();

    _animationController = AnimationController(
      vsync: this,
      lowerBound: 0.0,
      upperBound: 1.0,
      duration: Duration(milliseconds: widget.duration),
    );
    _animationController.value = 1;
    animation = Tween(begin: minScale, end: 1.0).animate(
      CurvedAnimation(parent: _animationController, curve: Curves.easeOut),
    );
  }

  @override
  void dispose() {
    _animationController.dispose();

    super.dispose();
  }

  bool get _hasMultiple {
    List<bool> list = [
      _hasTap,
      _hasSecondaryTap,
      _hasDoubleTap,
      _hasLongPress,
      _hasVerticalDrag,
      _hasHorizontalDrag,
      _hasForcePress,
      _hasPan,
      _hasScale
    ];
    return list.where((bool b) => b).length > 1;
  }

  bool get _hasTap =>
      widget.onTapDown != null ||
      widget.onTapUp != null ||
      widget.onTap != null ||
      widget.onTapCancel != null;

  bool get _hasSecondaryTap =>
      widget.onSecondaryTapDown != null ||
      widget.onSecondaryTapUp != null ||
      widget.onSecondaryTapCancel != null;

  bool get _hasDoubleTap => widget.onDoubleTap != null;

  bool get _hasLongPress =>
      widget.onLongPress != null ||
      widget.onLongPressStart != null ||
      widget.onLongPressMoveUpdate != null ||
      widget.onLongPressUp != null ||
      widget.onLongPressEnd != null;

  bool get _hasVerticalDrag =>
      widget.onVerticalDragDown != null ||
      widget.onVerticalDragStart != null ||
      widget.onVerticalDragUpdate != null ||
      widget.onVerticalDragEnd != null ||
      widget.onVerticalDragCancel != null;

  bool get _hasHorizontalDrag =>
      widget.onHorizontalDragDown != null ||
      widget.onHorizontalDragStart != null ||
      widget.onHorizontalDragUpdate != null ||
      widget.onHorizontalDragEnd != null ||
      widget.onHorizontalDragCancel != null;

  bool get _hasForcePress =>
      widget.onForcePressStart != null ||
      widget.onForcePressPeak != null ||
      widget.onForcePressUpdate != null ||
      widget.onForcePressEnd != null;

  bool get _hasPan =>
      widget.onPanDown != null ||
      widget.onPanStart != null ||
      widget.onPanUpdate != null ||
      widget.onPanCancel != null;

  bool get _hasScale =>
      widget.onScaleStart != null ||
      widget.onScaleUpdate != null ||
      widget.onScaleEnd != null;

  void enable() {
    if (!_isEnabled) {
      _animationController.value = 1.0;
      _isSpringDown = false;
      _isEnabled = true;
    }
  }

  void disable() {
    if (_isEnabled) {
      _animationController.value = 1.0;
      _isSpringDown = false;
      _isEnabled = false;
    }
  }

  void springDown() {
    if (!_isEnabled) return;

    if (_debugLevel > 0) print("springDown");

    _isSpringDown = true;
    _animationController.value = 0;
  }

  Future spring() async {
    if (!_isEnabled) return;

    if (_debugLevel > 0) print("spring-1");

    _isSpringDown = false;

    if (_hasMultiple) await Future.delayed(const Duration(milliseconds: 5));

    if (_debugLevel > 0) print("spring-2");

    if (!_isSpringDown) _animationController.forward();
  }

  Future springUp() async {
    if (!_isEnabled) return;

    if (_debugLevel > 0) print("springUp-1");

    _isSpringDown = false;

    if (_hasMultiple) await Future.delayed(const Duration(milliseconds: 500));

    if (_debugLevel > 0) print("springUp-2");

    if (!_isSpringDown) _animationController.value = 1;
  }

  Widget wrapper() {
    return GestureDetector(
      behavior: HitTestBehavior.translucent,
      onTapDown: !_hasTap
          ? null
          : (_) {
              springDown();
              if (widget.onTapDown != null && _isEnabled) widget.onTapDown!(_);
            },
      onTapUp: !_hasTap
          ? null
          : (_) {
              spring();
              if (widget.onTapUp != null && _isEnabled) widget.onTapUp!(_);
            },
      onTap: !_hasTap
          ? null
          : () {
              if (widget.onTap != null && _isEnabled) widget.onTap!();
            },
      onTapCancel: !_hasTap
          ? null
          : () {
              springUp();
              if (widget.onTapCancel != null && _isEnabled)
                widget.onTapCancel!();
            },
      onSecondaryTapDown: !_hasSecondaryTap
          ? null
          : (_) {
              springDown();
              if (widget.onSecondaryTapDown != null && _isEnabled)
                widget.onSecondaryTapDown!(_);
            },
      onSecondaryTapUp: !_hasSecondaryTap
          ? null
          : (_) {
              spring();
              if (widget.onSecondaryTapUp != null && _isEnabled)
                widget.onSecondaryTapUp!(_);
            },
      onSecondaryTapCancel: !_hasSecondaryTap
          ? null
          : () {
              springUp();
              if (widget.onSecondaryTapCancel != null && _isEnabled)
                widget.onSecondaryTapCancel!();
            },
      onDoubleTap: !_hasDoubleTap
          ? null
          : () {
              springDown();
              spring();
              if (widget.onDoubleTap != null && _isEnabled)
                widget.onDoubleTap!();
            },
      onLongPress: !_hasLongPress
          ? null
          : () {
              if (widget.onLongPress != null && _isEnabled)
                widget.onLongPress!();
            },
      onLongPressStart: !_hasLongPress
          ? null
          : (_) {
              springDown();
              if (widget.onLongPressStart != null && _isEnabled)
                widget.onLongPressStart!(_);
            },
      onLongPressMoveUpdate: !_hasLongPress
          ? null
          : (_) {
              if (widget.onLongPressMoveUpdate != null && _isEnabled)
                widget.onLongPressMoveUpdate!(_);
            },
      onLongPressUp: !_hasLongPress
          ? null
          : () {
              spring();
              if (widget.onLongPressUp != null && _isEnabled)
                widget.onLongPressUp!();
            },
      onLongPressEnd: !_hasLongPress
          ? null
          : (_) {
              if (widget.onLongPressEnd != null && _isEnabled)
                widget.onLongPressEnd!(_);
            },
      onVerticalDragDown: !_hasVerticalDrag
          ? null
          : (_) {
              if (widget.onVerticalDragDown != null && _isEnabled)
                widget.onVerticalDragDown!(_);
            },
      onVerticalDragStart: !_hasVerticalDrag
          ? null
          : (_) {
              springDown();
              if (widget.onVerticalDragStart != null && _isEnabled)
                widget.onVerticalDragStart!(_);
            },
      onVerticalDragUpdate: !_hasVerticalDrag
          ? null
          : (_) {
              if (widget.onVerticalDragUpdate != null && _isEnabled)
                widget.onVerticalDragUpdate!(_);
            },
      onVerticalDragEnd: !_hasVerticalDrag
          ? null
          : (_) {
              spring();
              if (widget.onVerticalDragEnd != null && _isEnabled)
                widget.onVerticalDragEnd!(_);
            },
      onVerticalDragCancel: !_hasVerticalDrag
          ? null
          : () {
              springUp();
              if (widget.onVerticalDragCancel != null && _isEnabled)
                widget.onVerticalDragCancel!();
            },
      onHorizontalDragDown: !_hasHorizontalDrag
          ? null
          : (_) {
              if (widget.onHorizontalDragDown != null && _isEnabled)
                widget.onHorizontalDragDown!(_);
            },
      onHorizontalDragStart: !_hasHorizontalDrag
          ? null
          : (_) {
              springDown();
              if (widget.onHorizontalDragStart != null && _isEnabled)
                widget.onHorizontalDragStart!(_);
            },
      onHorizontalDragUpdate: !_hasHorizontalDrag
          ? null
          : (_) {
              if (widget.onHorizontalDragUpdate != null && _isEnabled)
                widget.onHorizontalDragUpdate!(_);
            },
      onHorizontalDragEnd: !_hasHorizontalDrag
          ? null
          : (_) {
              spring();
              if (widget.onHorizontalDragEnd != null && _isEnabled)
                widget.onHorizontalDragEnd!(_);
            },
      onHorizontalDragCancel: !_hasHorizontalDrag
          ? null
          : () {
              springUp();
              if (widget.onHorizontalDragCancel != null && _isEnabled)
                widget.onHorizontalDragCancel!();
            },
      onForcePressStart: !_hasForcePress
          ? null
          : (_) {
              springDown();
              if (widget.onForcePressStart != null && _isEnabled)
                widget.onForcePressStart!(_);
            },
      onForcePressPeak: !_hasForcePress
          ? null
          : (_) {
              if (widget.onForcePressPeak != null && _isEnabled)
                widget.onForcePressPeak!(_);
            },
      onForcePressUpdate: !_hasForcePress
          ? null
          : (_) {
              if (widget.onForcePressUpdate != null && _isEnabled)
                widget.onForcePressUpdate!(_);
            },
      onForcePressEnd: !_hasForcePress
          ? null
          : (_) {
              spring();
              if (widget.onForcePressEnd != null && _isEnabled)
                widget.onForcePressEnd!(_);
            },
      onPanDown: !_hasPan
          ? null
          : (_) {
              if (widget.onPanDown != null && _isEnabled) widget.onPanDown!(_);
            },
      onPanStart: !_hasPan
          ? null
          : (_) {
              springDown();
              if (widget.onPanStart != null && _isEnabled)
                widget.onPanStart!(_);
            },
      onPanUpdate: !_hasPan
          ? null
          : (_) {
              if (widget.onPanUpdate != null && _isEnabled)
                widget.onPanUpdate!(_);
            },
      onPanEnd: !_hasPan
          ? null
          : (_) {
              spring();
              if (widget.onPanEnd != null && _isEnabled) widget.onPanEnd!(_);
            },
      onPanCancel: !_hasPan
          ? null
          : () {
              springUp();
              if (widget.onPanCancel != null && _isEnabled)
                widget.onPanCancel!();
            },
      onScaleStart: !_hasScale
          ? null
          : (_) {
              springDown();
              if (widget.onScaleStart != null && _isEnabled)
                widget.onScaleStart!(_);
            },
      onScaleUpdate: !_hasScale
          ? null
          : (_) {
              if (widget.onScaleUpdate != null && _isEnabled)
                widget.onScaleUpdate!(_);
            },
      onScaleEnd: !_hasScale
          ? null
          : (_) {
              spring();
              if (widget.onScaleEnd != null && _isEnabled)
                widget.onScaleEnd!(_);
            },
      child: widget.child,
    );
  }

  @override
  Widget build(BuildContext context) {
    return AnimatedBuilder(
      animation: animation,
      child: useCache ? child : null,
      builder: (BuildContext context, Widget? cachedChild) {
        return Transform.scale(
          scale: animation.value,
          child: useCache ? cachedChild : wrapper(),
        );
      },
    );
  }
}
