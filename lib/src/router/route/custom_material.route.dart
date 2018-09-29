import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/widgets.dart';

final Tween<Offset> _kBottomUpTween = Tween<Offset>(
  begin: const Offset(0.0, 0.25),
  end: Offset.zero,
);

class _MountainViewPageTransition extends StatelessWidget {
  _MountainViewPageTransition({
    Key key,
    @required bool fade,
    @required Animation<double> routeAnimation,
    @required this.child,
  })  : _positionAnimation = _kBottomUpTween.animate(
          CurvedAnimation(
            parent: routeAnimation, // The route's linear 0.0 - 1.0 animation.
            curve: Curves.fastOutSlowIn,
          ),
        ),
        _opacityAnimation = fade
            ? CurvedAnimation(
                parent: routeAnimation,
                curve: Curves.easeIn, // Eyeballed from other Material apps.
              )
            : const AlwaysStoppedAnimation<double>(1.0),
        super(key: key);

  final Animation<Offset> _positionAnimation;
  final Animation<double> _opacityAnimation;
  final Widget child;

  @override
  Widget build(BuildContext context) {
    return SlideTransition(
      position: _positionAnimation,
      child: FadeTransition(
        opacity: _opacityAnimation,
        child: child,
      ),
    );
  }
}

class CustomMaterialRoute<T> extends PageRoute<T> {
  CustomMaterialRoute({
    @required this.builder,
    this.maintainState = true,
    this.duration,
    RouteSettings settings,
    bool fullscreenDialog = false,
  })  : assert(builder != null),
        super(settings: settings, fullscreenDialog: fullscreenDialog) {
    assert(opaque);
  }

  final WidgetBuilder builder;
  final Duration duration;

  @override
  final bool maintainState;

  CupertinoPageRoute<T> get _cupertinoPageRoute {
    assert(_useCupertinoTransitions);
    _internalCupertinoPageRoute ??= CupertinoPageRoute<T>(
      builder: builder, // Not used.
      fullscreenDialog: fullscreenDialog,
      hostRoute: this,
    );
    return _internalCupertinoPageRoute;
  }

  CupertinoPageRoute<T> _internalCupertinoPageRoute;

  bool get _useCupertinoTransitions {
    return _internalCupertinoPageRoute?.popGestureInProgress == true ||
        Theme.of(navigator.context).platform == TargetPlatform.iOS;
  }

  @override
  Duration get transitionDuration =>
      duration ?? const Duration(milliseconds: 300);

  @override
  Color get barrierColor => null;

  @override
  String get barrierLabel => null;

  @override
  bool canTransitionFrom(TransitionRoute<dynamic> previousRoute) {
    return previousRoute is CustomMaterialRoute ||
        previousRoute is CupertinoPageRoute;
  }

  @override
  bool canTransitionTo(TransitionRoute<dynamic> nextRoute) {
    return (nextRoute is CustomMaterialRoute && !nextRoute.fullscreenDialog) ||
        (nextRoute is CupertinoPageRoute && !nextRoute.fullscreenDialog);
  }

  @override
  void dispose() {
    _internalCupertinoPageRoute?.dispose();
    super.dispose();
  }

  @override
  Widget buildPage(BuildContext context, Animation<double> animation,
      Animation<double> secondaryAnimation) {
    final Widget result = Semantics(
      scopesRoute: true,
      explicitChildNodes: true,
      child: builder(context),
    );
    assert(() {
      if (result == null) {
        throw FlutterError(
            'The builder for route "${settings.name}" returned null.\n'
            'Route builders must never return null.');
      }
      return true;
    }());
    return result;
  }

  @override
  Widget buildTransitions(BuildContext context, Animation<double> animation,
      Animation<double> secondaryAnimation, Widget child) {
    if (_useCupertinoTransitions) {
      return _cupertinoPageRoute.buildTransitions(
          context, animation, secondaryAnimation, child);
    } else {
      return _MountainViewPageTransition(
        routeAnimation: animation,
        child: child,
        fade: true,
      );
    }
  }

  @override
  String get debugLabel => '${super.debugLabel}(${settings.name})';
}
