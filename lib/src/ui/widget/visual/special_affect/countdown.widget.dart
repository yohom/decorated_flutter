import 'package:flutter/material.dart';

class Countdown extends StatelessWidget {
  const Countdown({
    Key key,
    @required this.initialData,
    this.duration = const Duration(seconds: 1),
    @required this.builder,
  }) : super(key: key);

  final int initialData;
  final Duration duration;
  final Widget Function(BuildContext, int) builder;

  @override
  Widget build(BuildContext context) {
    return StreamBuilder<int>(
      initialData: initialData,
      stream: Stream.periodic(duration, (count) => initialData - 1 - count)
          .take(initialData),
      builder: (context, snapshot) {
        return builder?.call(context, snapshot.data);
      },
    );
  }
}
