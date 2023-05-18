import 'dart:ui' as ui;

import 'package:flutter/material.dart';

/// 模糊子widget
class Blur extends StatelessWidget {
  const Blur({
    super.key,
    this.applyInsets = false,
    this.sigmaX = 2,
    this.sigmaY = 2,
    this.constraints,
    required this.child,
  });

  final bool applyInsets;
  final double sigmaX;
  final double sigmaY;
  final BoxConstraints? constraints;
  final Widget child;

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: applyInsets
          ? EdgeInsets.symmetric(horizontal: sigmaX * 3, vertical: sigmaY * 3)
          : EdgeInsets.zero,
      constraints: constraints ?? const BoxConstraints.expand(),
      child: ImageFiltered(
        imageFilter: ui.ImageFilter.blur(sigmaX: sigmaX, sigmaY: sigmaY),
        child: child,
      ),
    );
  }
}

/// 背景模糊
class BackgroundBlur extends StatelessWidget {
  const BackgroundBlur({
    super.key,
    this.background,
    required this.child,
    this.alignment = AlignmentDirectional.center,
    this.sigmaX = 2,
    this.sigmaY = 2,
    this.fit = StackFit.expand,
    this.clipped = false,
  });

  final Widget? background;
  final Widget child;
  final AlignmentGeometry alignment;
  final double sigmaX;
  final double sigmaY;
  final StackFit fit;
  final bool clipped;

  @override
  Widget build(BuildContext context) {
    Widget result = BackdropFilter(
      filter: ui.ImageFilter.blur(
        sigmaX: sigmaX,
        sigmaY: sigmaY,
      ),
      child: child,
    );

    if (background != null) {
      result = Stack(
        alignment: alignment,
        fit: fit,
        children: <Widget>[background!, result],
      );
    }

    if (clipped) {
      result = ClipRect(child: result);
    }

    return result;
  }
}

class BlurDialog extends StatelessWidget {
  const BlurDialog({
    super.key,
    required this.child,
    this.sigmaX = 2,
    this.sigmaY = 2,
    this.dismissible = true,
    this.backgroundColor,
    this.elevation,
    this.insetAnimationDuration = const Duration(milliseconds: 100),
    this.insetAnimationCurve = Curves.decelerate,
    this.insetPadding = const EdgeInsets.all(24),
    this.clipBehavior = Clip.none,
    this.shape,
  });

  final Widget child;
  final bool dismissible;
  final double sigmaX;
  final double sigmaY;
  final Color? backgroundColor;
  final double? elevation;
  final Duration insetAnimationDuration;
  final Curve insetAnimationCurve;
  final EdgeInsets? insetPadding;
  final Clip clipBehavior;
  final ShapeBorder? shape;

  @override
  Widget build(BuildContext context) {
    return BackdropFilter(
      filter: ui.ImageFilter.blur(sigmaX: sigmaX, sigmaY: sigmaY),
      child: Dialog(
        backgroundColor: backgroundColor,
        elevation: elevation,
        insetAnimationDuration: insetAnimationDuration,
        insetAnimationCurve: insetAnimationCurve,
        insetPadding: insetPadding,
        clipBehavior: clipBehavior,
        shape: shape,
        child: child,
      ),
    );
  }
}
