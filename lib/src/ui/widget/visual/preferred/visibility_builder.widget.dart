// @dart=2.9

import 'package:decorated_flutter/decorated_flutter.dart';
import 'package:flutter/material.dart';

class VisibilityBuilder extends StatelessWidget {
  const VisibilityBuilder({
    Key key,
    this.initialValue = true,
    @required this.visibilityStream,
    @required this.child,
  }) : super(key: key);

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
