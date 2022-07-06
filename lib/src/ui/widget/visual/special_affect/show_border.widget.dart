import 'package:flutter/material.dart';

class ShowBorder extends StatelessWidget {
  const ShowBorder(this.child, {super.key});

  final Widget child;

  @override
  Widget build(BuildContext context) {
    return Container(
      decoration: BoxDecoration(border: Border.all()),
      child: child,
    );
  }
}
