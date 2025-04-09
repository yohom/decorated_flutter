import 'package:flutter/material.dart';

class BackGestureDetector extends StatelessWidget {
  const BackGestureDetector({
    super.key,
    this.enabled = true,
    required this.child,
    this.onBack,
    this.velocityThreshold = 500,
    this.behavior = HitTestBehavior.opaque,
  });

  /// 是否开启
  final bool enabled;

  /// 返回的回调
  final VoidCallback? onBack;

  /// 触发返回的速度阈值 单位 pixelsPerSecond.dx
  final int velocityThreshold;

  final HitTestBehavior behavior;
  final Widget child;

  @override
  Widget build(BuildContext context) {
    return Stack(
      children: [
        child,
        if (enabled)
          Positioned(
            left: 0,
            top: 0,
            bottom: 0,
            width: 64,
            child: GestureDetector(
              behavior: behavior,
              onPanEnd: (details) {
                if (details.velocity.pixelsPerSecond.dx > velocityThreshold) {
                  if (onBack != null) {
                    onBack!();
                  } else {
                    Navigator.of(context).pop();
                  }
                }
              },
            ),
          ),
      ],
    );
  }
}
