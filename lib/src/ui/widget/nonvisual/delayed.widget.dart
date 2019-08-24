import 'package:decorated_flutter/src/ui/widget/visual/preferred/preferred_async_builder.widget.dart';
import 'package:flutter/material.dart';

class Delayed<T> extends StatelessWidget {
  const Delayed({
    Key key,
    @required this.child,
    @required this.duration,
    this.showLoading = true,
  }) : super(key: key);

  final Widget child;
  final bool showLoading;
  final Duration duration;

  @override
  Widget build(BuildContext context) {
    return PreferredFutureBuilder(
      showLoading: showLoading,
      future: Future.delayed(duration, () => 0),
      builder: (_) => child,
    );
  }
}
