import 'package:decorated_flutter/decorated_flutter.dart';
import 'package:flutter/material.dart';

class VisibilityBuilder extends StatelessWidget {
  const VisibilityBuilder({
    super.key,
    this.initialValue = true,
    required this.visibilityStream,
    required this.child,
  });

  final bool initialValue;
  final Stream<bool> visibilityStream;
  final Widget child;

  @override
  Widget build(BuildContext context) {
    return Subscriber<bool>(
      initialData: initialValue,
      stream: visibilityStream,
      builder: (data) {
        return Visibility(visible: data, child: child);
      },
    );
  }
}
