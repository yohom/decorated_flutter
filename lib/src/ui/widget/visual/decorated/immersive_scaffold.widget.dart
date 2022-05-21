import 'package:decorated_flutter/decorated_flutter.dart';
import 'package:flutter/material.dart';

/// 沉浸式的可滚动容器
///
/// 使用场景为比较长的滚动视图, 向上滚动一段距离后, 显示(渐显)一个header
class ImmersiveScrollable extends StatefulWidget {
  const ImmersiveScrollable({
    Key? key,
    required this.header,
    required this.body,
    this.fadeExtent = 200,
  }) : super(key: key);

  /// 头部
  ///
  /// 滚动之后会渐显
  final Widget header;

  /// 可滚动的部分
  final Widget body;

  /// 滚动[fadeExtent]距离后显示完整的[header]
  final double fadeExtent;

  @override
  State<ImmersiveScrollable> createState() => _ImmersiveScrollableState();
}

class _ImmersiveScrollableState extends State<ImmersiveScrollable>
    with SingleTickerProviderStateMixin {
  late AnimationController _headerOpacity;

  @override
  void initState() {
    super.initState();
    _headerOpacity = AnimationController(vsync: this);
  }

  @override
  Widget build(BuildContext context) {
    return NotificationListener<ScrollUpdateNotification>(
      onNotification: (update) {
        setState(() {
          final rawOpacity = update.metrics.pixels / widget.fadeExtent;
          _headerOpacity.value = rawOpacity.clamp(0, 1);
        });
        return false;
      },
      child: DecoratedStack(
        top: _headerOpacity.value != 0
            ? FadeTransition(opacity: _headerOpacity, child: widget.header)
            : null,
        children: [SingleChildScrollView(child: widget.body)],
      ),
    );
  }
}
