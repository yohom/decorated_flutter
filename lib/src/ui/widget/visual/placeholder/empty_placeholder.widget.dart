import 'package:flutter/material.dart';

class EmptyPlaceholder extends StatelessWidget {
  const EmptyPlaceholder({
    super.key,
    this.sliver = false,
    this.child,
  });

  final bool sliver;
  final Widget? child;

  @override
  Widget build(BuildContext context) {
    Widget result = child ?? const Center(child: Text('没有数据'));

    if (sliver) {
      result = SliverToBoxAdapter(child: result);
    }
    return result;
  }
}
