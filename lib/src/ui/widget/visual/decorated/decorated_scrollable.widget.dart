import 'package:decorated_flutter/src/extension/build_context.x.dart';
import 'package:flutter/material.dart';

import 'load_more.widget.dart';

final class DecoratedScrollableConfig {
  const DecoratedScrollableConfig({
    this.show = true,
    this.decoration,
    this.duration = const Duration(milliseconds: 320),
    this.curve = Curves.decelerate,
    this.customBuilder,
  });

  final bool show;
  final BoxDecoration? decoration;
  final Duration duration;
  final Curve curve;
  final Widget Function(bool show, Widget child)? customBuilder;
}

/// 内部Scrollable滚动时, 动画显示[BoxDecoration]
///
/// 默认效果为顶部显示1逻辑像素的分隔线
class DecoratedScrollable extends StatefulWidget {
  const DecoratedScrollable({
    super.key,
    this.config = const DecoratedScrollableConfig(),
    required this.child,
    this.loadMoreConfig,
    this.reverse = false,
  });

  final DecoratedScrollableConfig config;
  final Widget child;

  /// 可选的加载更多配置，适用于任意内部可滚动组件。
  final LoadMoreConfig? loadMoreConfig;

  /// 内部滚动组件是否使用reverse方向。
  final bool reverse;

  @override
  State<DecoratedScrollable> createState() => _DecoratedScrollableState();
}

class _DecoratedScrollableState extends State<DecoratedScrollable> {
  bool _showDecoration = false;

  @override
  Widget build(BuildContext context) {
    final BoxDecoration decoration;
    if (_showDecoration) {
      decoration = widget.config.decoration ??
          BoxDecoration(
            border: Border(
              top: BorderSide(color: context.dividerColor, width: 1),
            ),
          );
    } else {
      decoration = const BoxDecoration();
    }
    final decoratedChild =
        widget.config.customBuilder?.call(_showDecoration, widget.child) ??
            AnimatedContainer(
              duration: widget.config.duration,
              curve: widget.config.curve,
              foregroundDecoration: decoration,
              child: widget.child,
            );
    final result = widget.loadMoreConfig == null
        ? decoratedChild
        : LoadMore(
            config: widget.loadMoreConfig!,
            reverse: widget.reverse,
            child: decoratedChild,
          );

    return NotificationListener<ScrollUpdateNotification>(
      onNotification: (notification) {
        // 只处理y轴方向
        if (notification.metrics.axis == Axis.horizontal) return false;

        if (notification.metrics.pixels > 0 && !_showDecoration) {
          setState(() {
            _showDecoration = true;
          });
        } else if (notification.metrics.pixels <= 0) {
          setState(() {
            _showDecoration = false;
          });
        }
        return false;
      },
      child: result,
    );
  }
}
