// @dart=2.9

import 'package:decorated_flutter/src/ui/widget/visual/preferred/preferred_async_builder.widget.dart';
import 'package:flutter/material.dart';

class Delayed<T> extends StatelessWidget {
  const Delayed({
    Key key,
    @required this.child,
    @required this.duration,
    this.showLoading = true,
    this.loadingWidget,
    this.backgroundColor = Colors.black,
  }) : super(key: key);

  final Widget child;
  final bool showLoading;
  final Duration duration;
  final Widget loadingWidget;
  final Color backgroundColor;

  @override
  Widget build(BuildContext context) {
    return PreferredFutureBuilder(
      showLoading: showLoading,
      loadingPlaceholder: loadingWidget ??
          Container(
            color: backgroundColor,
            child: Center(child: CircularProgressIndicator()),
          ),
      future: Future.delayed(duration, () => 0),
      builder: (_) => child,
    );
  }
}
