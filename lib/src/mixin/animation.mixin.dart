import 'package:flutter/cupertino.dart';

mixin AnimationMixin<T extends StatefulWidget>
    on State<T>, SingleTickerProviderStateMixin<T> {
  @protected
  Animation animation;
  @protected
  AnimationController animationController;

  @override
  void initState() {
    super.initState();
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
    super.dispose();
  }
}
