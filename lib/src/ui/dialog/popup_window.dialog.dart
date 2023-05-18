import 'package:flutter/material.dart';

const double _kWindowCloseIntervalEnd = 2.0 / 3.0;
const Duration _kWindowDuration = Duration(milliseconds: 300);

typedef AnimatedWidgetBuilder = Widget Function(
  BuildContext context,
  Animation<double> animation,
  Animation<double> secondaryAnimation,
);

/// 不是很好用 :(
class PopupWindowButton<T> extends StatefulWidget {
  const PopupWindowButton({
    super.key,
    required this.buttonBuilder,
    required this.windowBuilder,
    this.offset = Offset.zero,
    this.duration = _kWindowDuration,
    this.onWindowShow,
    this.onWindowDismiss,
  });

  /// 显示按钮button
  /// the builder for child,
  /// button which clicked will popup a window
  final WidgetBuilder buttonBuilder;

  /// window 出现的位置。
  /// where window is in relation to button.
  final Offset offset;

  /// 按钮按钮后到显示window 出现的时间
  /// the transition duration before [buttonBuilder] show up
  final Duration duration;

  /// 需要显示的window
  /// the target window
  final AnimatedWidgetBuilder windowBuilder;

  final VoidCallback? onWindowShow;

  final VoidCallback? onWindowDismiss;

  @override
  _PopupWindowButtonState createState() {
    return _PopupWindowButtonState();
  }

  static _PopupWindowButtonState? of(BuildContext context) {
    final _PopupWindowScope? scope =
        context.dependOnInheritedWidgetOfExactType<_PopupWindowScope>();
    return scope?.state;
  }
}

void showWindow<T>({
  required BuildContext context,
  required RelativeRect position,
  Duration duration = _kWindowDuration,
  String? semanticLabel,
  required AnimatedWidgetBuilder windowBuilder,
  VoidCallback? onWindowShow,
  VoidCallback? onWindowDismiss,
}) {
  Navigator.push(
    context,
    _PopupWindowRoute<T>(
      position: position,
      duration: duration,
      semanticLabel: semanticLabel,
      barrierLabel: MaterialLocalizations.of(context).modalBarrierDismissLabel,
      windowBuilder: windowBuilder,
      onWindowShow: onWindowShow,
      onWindowDismiss: onWindowDismiss,
    ),
  );
}

class _PopupWindowButtonState<T> extends State<PopupWindowButton> {
  void showPopupWindow() {
    final button = context.findRenderObject() as RenderBox;
    final overlay = Overlay.of(context).context.findRenderObject() as RenderBox;
    final RelativeRect position = RelativeRect.fromRect(
      Rect.fromPoints(
        button.localToGlobal(widget.offset, ancestor: overlay),
        button.localToGlobal(button.size.bottomRight(Offset.zero),
            ancestor: overlay),
      ),
      Offset.zero & overlay.size,
    );

    showWindow<T>(
      context: context,
      position: position,
      duration: widget.duration,
      windowBuilder: widget.windowBuilder,
      onWindowShow: widget.onWindowShow,
      onWindowDismiss: widget.onWindowDismiss,
    );
  }

  @override
  Widget build(BuildContext context) {
    return _PopupWindowScope(
        state: this,
        child: InkWell(
          onTap: showPopupWindow,
          child: widget.buttonBuilder(context),
        ));
  }
}

class _PopupWindowRoute<T> extends PopupRoute<T> {
  _PopupWindowRoute({
    required this.position,
    this.barrierLabel,
    this.semanticLabel,
    this.duration = _kWindowDuration,
    required this.windowBuilder,
    this.onWindowShow,
    this.onWindowDismiss,
  });

  @override
  Animation<double> createAnimation() {
    return CurvedAnimation(
      parent: super.createAnimation(),
      curve: Curves.linear,
      reverseCurve: const Interval(0.0, _kWindowCloseIntervalEnd),
    );
  }

  final RelativeRect position;
  final String? semanticLabel;
  @override
  final String? barrierLabel;
  final Duration duration;
  final AnimatedWidgetBuilder windowBuilder;
  final VoidCallback? onWindowShow;
  final VoidCallback? onWindowDismiss;

  @override
  Duration get transitionDuration => duration;

  @override
  bool get barrierDismissible => true;

  @override
  Color get barrierColor => Colors.transparent;

  @override
  bool didPop(T? result) {
    onWindowDismiss?.call();
    return super.didPop(result);
  }

  @override
  TickerFuture didPush() {
    onWindowShow?.call();
    return super.didPush();
  }

  @override
  Widget buildPage(BuildContext context, Animation<double> animation,
      Animation<double> secondaryAnimation) {
    return CustomSingleChildLayout(
      delegate: _PopupWindowLayout(position),
      child: AnimatedBuilder(
        animation: animation,
        builder: (BuildContext context, Widget? child) {
          return windowBuilder(context, animation, secondaryAnimation);
        },
      ),
    );
  }
}

class _PopupWindowLayout extends SingleChildLayoutDelegate {
  _PopupWindowLayout(this.position);

  // Rectangle of underlying button, relative to the overlay's dimensions.
  final RelativeRect position;

  // We put the child wherever position specifies, so long as it will fit within
  // the specified parent size padded (inset) by 8. If necessary, we adjust the
  // child's position so that it fits.

  @override
  BoxConstraints getConstraintsForChild(BoxConstraints constraints) {
    // The menu can be at most the size of the overlay minus 8.0 pixels in each
    // direction.
    return BoxConstraints.loose(constraints.biggest);
  }

  @override
  Offset getPositionForChild(Size size, Size childSize) {
    // size: The size of the overlay.
    // childSize: The size of the menu, when fully open, as determined by
    // getConstraintsForChild.

    // Find the ideal vertical position.
    double y = position.top;

    // Find the ideal horizontal position.
    double x = 0;
    if (position.left > position.right) {
      // Menu button is closer to the right edge, so grow to the left, aligned to the right edge.
      x = size.width - position.right - childSize.width;
    } else if (position.left < position.right) {
      // Menu button is closer to the left edge, so grow to the right, aligned to the left edge.
      x = position.left;
    }
    return Offset(x, y);
  }

  @override
  bool shouldRelayout(_PopupWindowLayout oldDelegate) {
    return position != oldDelegate.position;
  }
}

class _PopupWindowScope extends InheritedWidget {
  const _PopupWindowScope({super.key, this.state, required super.child});

  final _PopupWindowButtonState? state;

  @override
  bool updateShouldNotify(_PopupWindowScope oldWidget) {
    return state != oldWidget.state;
  }
}
