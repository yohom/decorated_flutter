import 'package:flutter/material.dart';

import '../../../ui.export.dart';

class RxAnimatedSize extends StatelessWidget {
  const RxAnimatedSize(
    this.data, {
    super.key,
    this.initialData = false,
    this.duration = const Duration(milliseconds: 300),
    required this.child,
  });

  final Stream<bool> data;
  final bool initialData;
  final Duration duration;
  final Widget child;

  @override
  Widget build(BuildContext context) {
    return StreamBuilder<bool>(
      stream: data,
      initialData: initialData,
      builder: (_, snapshot) {
        return AnimatedSize(
          duration: duration,
          alignment: Alignment.topCenter,
          child: KeyedSubtree(
            key: const Key('RxAnimatedSize'),
            child: snapshot.requireData ? child : NIL,
          ),
        );
      },
    );
  }
}
