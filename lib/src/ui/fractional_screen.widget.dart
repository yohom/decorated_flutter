import 'package:flutter/material.dart';
import 'package:framework/framework.dart';

class FractionalScreen extends StatelessWidget {
  const FractionalScreen({
    Key key,
    this.widthFactor = double.infinity,
    this.heightFactor = double.infinity,
    this.child,
  }) : super(key: key);

  /// 占屏幕宽度百分比
  final double widthFactor;

  /// 占屏幕高度百分比
  final double heightFactor;

  /// child
  final Widget child;

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      width: Global.screenHeight * widthFactor,
      height: Global.screenWidth * heightFactor,
      child: child,
    );
  }
}
