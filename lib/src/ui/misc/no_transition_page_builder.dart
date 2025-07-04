import 'package:flutter/material.dart';

class NoTransitionsPageBuilder extends PageTransitionsBuilder {
  const NoTransitionsPageBuilder();

  @override
  Widget buildTransitions<T>(
    PageRoute<T> route,
    BuildContext context,
    Animation<double> animation,
    Animation<double> secondaryAnimation,
    Widget child,
  ) {
    return child; // 不加动画
  }
}
