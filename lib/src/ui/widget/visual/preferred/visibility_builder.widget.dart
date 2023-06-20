import 'package:decorated_flutter/decorated_flutter.dart';
import 'package:flutter/material.dart';

@Deprecated('使用RxVisibility代替')
typedef VisibilityBuilder = RxVisibility;

class RxVisibility extends StatelessWidget {
  const RxVisibility({
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
