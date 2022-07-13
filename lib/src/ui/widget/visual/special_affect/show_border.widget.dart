import 'package:flutter/material.dart';

@Deprecated('使用framework自带的GridPaper')
class ShowBorder extends StatelessWidget {
  const ShowBorder({
    super.key,
    required this.child,
    this.color = Colors.black,
  });

  final Color color;
  final Widget child;

  @override
  Widget build(BuildContext context) {
    return Container(
      foregroundDecoration: BoxDecoration(border: Border.all(color: color)),
      child: child,
    );
  }
}
