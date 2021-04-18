import 'package:decorated_flutter/decorated_flutter.dart';
import 'package:flutter/material.dart';

class Countdown extends StatelessWidget {
  const Countdown({
    Key? key,
    required this.initialData,
    this.duration = const Duration(seconds: 1),
    required this.builder,
    this.onPressed,
  }) : super(key: key);

  final int initialData;
  final Duration duration;
  final Widget Function(BuildContext, int?) builder;
  final ContextCallback? onPressed;

  @override
  Widget build(BuildContext context) {
    Widget result = StreamBuilder<int>(
      initialData: initialData,
      stream: Stream.periodic(duration, (count) => initialData - 1 - count)
          .take(initialData),
      builder: (context, snapshot) {
        return builder(context, snapshot.data);
      },
    );

    if (onPressed != null) {
      result = GestureDetector(onTap: () => onPressed!(context), child: result);
    }

    return result;
  }
}
