import 'package:flutter/material.dart';
import 'package:framework/framework.dart';

class FractionalScreen extends StatelessWidget {
  const FractionalScreen({
    Key key,
    this.fractionalWidth = double.infinity,
    this.fractionalHeight = double.infinity,
    this.child,
  }) : super(key: key);

  /// 占屏幕宽度百分比
  final double fractionalWidth;

  /// 占屏幕高度百分比
  final double fractionalHeight;

  /// child
  final Widget child;

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      width: Global.screenHeight * fractionalWidth,
      height: Global.screenWidth * fractionalHeight,
      child: child,
    );
  }
}
