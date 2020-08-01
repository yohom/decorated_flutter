import 'package:flutter/material.dart';

class DecoratedStack extends StatelessWidget {
  const DecoratedStack(
    this.data, {
    Key key,
    this.padding,
    this.margin,
    this.decoration,
    this.style = const TextStyle(),
    this.safeArea,
    this.onPressed,
    this.maxLines,
    this.textAlign,
    this.overflow,
    this.constraints,
    this.expanded = false,
    this.stackFit,
    this.alignment,
    this.topStart,
    this.topEnd,
    this.bottomStart,
    this.bottomEnd,
    this.center,
    @required this.children,
  }) : super(key: key);

  final EdgeInsetsGeometry padding;
  final EdgeInsetsGeometry margin;
  final BoxDecoration decoration;
  final TextStyle style;
  final String data;
  final bool safeArea;
  final ValueChanged<String> onPressed;
  final int maxLines;
  final TextAlign textAlign;
  final BoxConstraints constraints;
  final bool expanded;

  final Widget topStart;
  final Widget topEnd;
  final Widget bottomStart;
  final Widget bottomEnd;
  final Widget center;

  final StackFit stackFit;
  final AlignmentGeometry alignment;
  final Overflow overflow;
  final List<Widget> children;

  @override
  Widget build(BuildContext context) {
    Widget result = Stack(
      alignment: alignment ?? AlignmentDirectional.topStart,
      fit: stackFit ?? StackFit.loose,
      overflow: overflow ?? Overflow.clip,
      children: <Widget>[
        ...children,
        if (topStart != null) Positioned(top: 0, left: 0, child: topStart),
        if (topEnd != null) Positioned(top: 0, right: 0, child: topEnd),
        if (bottomStart != null)
          Positioned(bottom: 0, left: 0, child: bottomStart),
        if (bottomEnd != null)
          Positioned(bottom: 0, right: 0, child: bottomEnd),
        if (center != null)
          Positioned(bottom: 0, right: 0, top: 0, left: 0, child: center),
      ],
    );

    if (decoration != null || padding != null || margin != null) {
      result = Container(
        margin: margin,
        padding: padding,
        decoration: decoration,
        constraints: constraints,
        child: result,
      );
    }

    if (safeArea != null) {
      result = SafeArea(child: result);
    }

    if (onPressed != null) {
      result = GestureDetector(
        onTap: () => onPressed(data),
        child: result,
      );
    }

    if (expanded) {
      result = Expanded(child: result);
    }

    return result;
  }
}
