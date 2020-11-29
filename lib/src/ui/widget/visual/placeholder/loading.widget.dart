import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';

class LoadingWidget extends StatelessWidget {
  const LoadingWidget({
    Key key,
    this.height,
    this.width,
    this.margin,
    this.color,
    this.backgroundColor,
    this.sliver = false,
  }) : super(key: key);

  final double width;
  final double height;
  final EdgeInsets margin;
  final Color color;
  final Color backgroundColor;
  final bool sliver;

  @override
  Widget build(BuildContext context) {
    Widget result = Center(
      child: CircularProgressIndicator(
        valueColor: AlwaysStoppedAnimation(
          color ?? Theme.of(context).primaryColor,
        ),
      ),
    );
    if (height != null || width != null) {
      result = SizedBox(height: height, width: width, child: result);
    }
    if (margin != null) {
      result = Padding(padding: margin, child: result);
    }
    if (backgroundColor != null) {
      result = Container(color: backgroundColor, child: result);
    }
    if (sliver) {
      result = SliverToBoxAdapter(child: result);
    }
    return result;
  }
}
