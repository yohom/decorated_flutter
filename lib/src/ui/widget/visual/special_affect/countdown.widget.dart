import 'package:decorated_flutter/decorated_flutter.dart';
import 'package:flutter/material.dart';

class Countdown extends StatefulWidget {
  const Countdown({
    super.key,
    required this.initialData,
    this.interval = const Duration(seconds: 1),
    required this.builder,
    this.onPressed,
    this.onZero,
  });

  final int initialData;
  final Duration interval;
  final Widget Function(BuildContext context, int count) builder;
  final ContextCallback? onPressed;
  final VoidCallback? onZero;

  @override
  _CountdownState createState() => _CountdownState();
}

class _CountdownState extends State<Countdown> {
  late Stream<int> _countStream;
  late bool isZeroed;

  @override
  void initState() {
    super.initState();
    isZeroed = false;
    _countStream = _createCountStream();
  }

  @override
  void didUpdateWidget(covariant Countdown oldWidget) {
    super.didUpdateWidget(oldWidget);
    if (oldWidget.initialData == widget.initialData &&
        oldWidget.interval == widget.interval) {
      return;
    }

    _countStream = _createCountStream();
    if (widget.initialData > 0) isZeroed = false;
  }

  @override
  Widget build(BuildContext context) {
    Widget result = StreamBuilder<int>(
      key: ObjectKey(_countStream),
      initialData: widget.initialData,
      stream: _countStream,
      builder: (context, snapshot) {
        if (snapshot.requireData <= 0 && !isZeroed && mounted) {
          isZeroed = true;
          widget.onZero?.call();
        }
        return widget.builder(context, snapshot.data!);
      },
    );

    if (widget.onPressed != null) {
      result = GestureDetector(
        onTap: () => widget.onPressed!(context),
        child: result,
      );
    }

    return result;
  }

  Stream<int> _createCountStream() {
    return Stream.periodic(
      widget.interval,
      (count) => widget.initialData - 1 - count,
    ).take(widget.initialData);
  }
}
