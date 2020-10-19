import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';

class LoadingWidget extends StatelessWidget {
  const LoadingWidget({
    Key key,
    this.height,
    this.width,
    this.sliver = false,
  }) : super(key: key);

  final double width;
  final double height;
  final bool sliver;

  @override
  Widget build(BuildContext context) {
    Widget result = Center(
      child: CupertinoActivityIndicator(),
    );
    if (height != null || width != null) {
      result = SizedBox(height: height, width: width, child: result);
    }
    if (sliver) {
      result = SliverToBoxAdapter(child: result);
    }
    return result;
  }
}
