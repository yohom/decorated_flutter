import 'package:flutter/material.dart';

/// 使用primaryColor的Icon
class PrimaryIcon extends StatelessWidget {
  final IconData icon;
  final double size;
  final String semanticLabel;
  final TextDirection textDirection;

  const PrimaryIcon(
    this.icon, {
    Key key,
    this.size,
    this.semanticLabel,
    this.textDirection,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Icon(
      icon,
      size: size,
      color: Theme.of(context).primaryColor,
      semanticLabel: semanticLabel,
      textDirection: textDirection,
    );
  }
}
