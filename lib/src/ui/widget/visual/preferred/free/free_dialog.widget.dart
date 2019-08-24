import 'package:flutter/material.dart';

/// 解除了Material Design对于Dialog的边距限制的Dialog
/// 大体部分之间拷贝了原始的[Dialog]类, 就修改了下[padding]
class FreeDialog extends StatelessWidget {
  const FreeDialog({
    Key key,
    this.child,
    this.insetAnimationDuration = const Duration(milliseconds: 100),
    this.insetAnimationCurve = Curves.decelerate,
  }) : super(key: key);

  final Widget child;

  final Duration insetAnimationDuration;

  final Curve insetAnimationCurve;

  Color _getColor(BuildContext context) {
    return Theme.of(context).dialogBackgroundColor;
  }

  @override
  Widget build(BuildContext context) {
    return AnimatedPadding(
      padding: MediaQuery.of(context).viewInsets,
      duration: insetAnimationDuration,
      curve: insetAnimationCurve,
      child: MediaQuery.removeViewInsets(
        removeLeft: true,
        removeTop: true,
        removeRight: true,
        removeBottom: true,
        context: context,
        child: Center(
          child: ConstrainedBox(
            constraints: const BoxConstraints(minWidth: 280.0),
            child: Material(
              elevation: 24.0,
              color: _getColor(context),
              type: MaterialType.card,
              child: child,
            ),
          ),
        ),
      ),
    );
  }
}
