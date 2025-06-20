import 'package:decorated_flutter/src/ui/ui.export.dart';
import 'package:flutter/material.dart';

class Delayed<T> extends StatelessWidget {
  const Delayed({
    super.key,
    required this.child,
    required this.duration,
    this.showLoading = true,
    this.loadingWidget,
    this.backgroundColor = Colors.black,
  });

  final Widget child;
  final bool showLoading;
  final Duration duration;
  final Widget? loadingWidget;
  final Color backgroundColor;

  @override
  Widget build(BuildContext context) {
    if (duration == Duration.zero) return child;
    return SingleSubscriber(
      showLoading: showLoading,
      loadingPlaceholder: loadingWidget ??
          Container(
            color: backgroundColor,
            child: const Center(child: CircularProgressIndicator()),
          ),
      future: Future.delayed(duration, () => 0),
      builder: (_) => child,
    );
  }
}
