

import 'package:flutter/material.dart';

class GradientButton extends StatelessWidget {
  final Widget child;
  final Gradient? gradient;
  final double width;
  final double height;
  final Function? onPressed;
  final BorderRadius? borderRadius;
  final BoxShadow boxShadow;

  const GradientButton({
    super.key,
    required this.child,
    this.gradient,
    this.width = double.infinity,
    this.height = 48.0,
    this.onPressed,
    this.borderRadius,
    this.boxShadow = const BoxShadow(
      color: Colors.grey,
      offset: Offset(0.0, 0.0),
      blurRadius: 8,
    ),
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      width: width,
      height: height,
      decoration: BoxDecoration(
        borderRadius: borderRadius,
        gradient: gradient,
        boxShadow: [boxShadow],
      ),
      child: Material(
        color: Colors.transparent,
        child: InkWell(
          onTap: onPressed as void Function()?,
          child: Center(
            child: child,
          ),
        ),
      ),
    );
  }
}
