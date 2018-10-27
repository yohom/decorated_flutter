import 'package:flutter/material.dart';

class DecoratedRow extends StatelessWidget {
  const DecoratedRow({
    Key key,
    this.padding,
    this.margin,
    this.mainAxisAlignment = MainAxisAlignment.start,
    this.mainAxisSize = MainAxisSize.max,
    this.crossAxisAlignment = CrossAxisAlignment.center,
    this.children,
  }) : super(key: key);

  final List<Widget> children;
  final EdgeInsets padding;
  final EdgeInsets margin;
  final MainAxisAlignment mainAxisAlignment;
  final MainAxisSize mainAxisSize;
  final CrossAxisAlignment crossAxisAlignment;

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: padding,
      margin: margin,
      child: Row(
        mainAxisAlignment: mainAxisAlignment,
        mainAxisSize: mainAxisSize,
        crossAxisAlignment: crossAxisAlignment,
        children: children,
      ),
    );
  }
}

class DecoratedColumn extends StatelessWidget {
  const DecoratedColumn({
    Key key,
    this.padding,
    this.margin,
    this.mainAxisAlignment = MainAxisAlignment.start,
    this.mainAxisSize = MainAxisSize.max,
    this.crossAxisAlignment = CrossAxisAlignment.center,
    this.children,
  }) : super(key: key);

  final List<Widget> children;
  final EdgeInsets padding;
  final EdgeInsets margin;
  final MainAxisAlignment mainAxisAlignment;
  final MainAxisSize mainAxisSize;
  final CrossAxisAlignment crossAxisAlignment;

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: padding,
      margin: margin,
      child: Column(
        mainAxisAlignment: mainAxisAlignment,
        mainAxisSize: mainAxisSize,
        crossAxisAlignment: crossAxisAlignment,
        children: children,
      ),
    );
  }
}
