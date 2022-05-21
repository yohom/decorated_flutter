import 'package:flutter/material.dart';

class InterruptNotification extends StatelessWidget {
  const InterruptNotification({
    Key? key,
    this.interrupt = true,
    required this.child,
  }) : super(key: key);

  final bool interrupt;
  final Widget child;

  @override
  Widget build(BuildContext context) {
    return interrupt
        ? NotificationListener(onNotification: (_) => true, child: child)
        : child;
  }
}
