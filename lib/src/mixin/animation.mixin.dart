import 'package:flutter/cupertino.dart';

mixin AnimationMixin<T extends StatefulWidget>
    on State<T>, SingleTickerProviderStateMixin<T> {
  @protected
  late Animation animation;
  @protected
  late AnimationController animationController;
  @protected
  late bool animationDisposed;

  @override
  void initState() {
    super.initState();
    animationDisposed = false;
    animationController = AnimationController(duration: duration, vsync: this);
    animation = CurvedAnimation(
      parent: animationController,
      curve: curve,
      reverseCurve: reverseCurve,
    );
  }

  Duration get duration;

  Curve get curve => Curves.linear;

  Curve get reverseCurve => curve;

  @override
  void dispose() {
    animationController.dispose();
    animationDisposed = true;
    super.dispose();
  }
}
