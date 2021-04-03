import 'package:decorated_flutter/decorated_flutter.dart';
import 'package:decorated_flutter/src/bloc/bloc.export.dart';
import 'package:flutter/material.dart';

class VisibilityBuilder extends StatelessWidget {
  const VisibilityBuilder({
    Key key,
    this.initialValue = true,
    @required this.visibilityIO,
    @required this.child,
  }) : super(key: key);

  final bool initialValue;
  final BoolOutput visibilityIO;
  final Widget child;

  @override
  Widget build(BuildContext context) {
    return Subscriber<bool>(
      initialData: initialValue,
      stream: visibilityIO.stream,
      builder: (data) {
        return Visibility(visible: data, child: child);
      },
    );
  }
}
