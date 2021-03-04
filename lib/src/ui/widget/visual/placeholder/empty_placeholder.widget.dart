// @dart=2.9

import 'package:flutter/material.dart';

class EmptyPlaceholder extends StatelessWidget {
  const EmptyPlaceholder({
    Key key,
    this.sliver = false,
  }) : super(key: key);

  final bool sliver;

  @override
  Widget build(BuildContext context) {
    Widget result = Center(
      child: Text('没有数据'),
    );
    if (sliver) {
      result = SliverToBoxAdapter(child: result);
    }
    return result;
  }
}
