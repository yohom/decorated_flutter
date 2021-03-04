// @dart=2.9

import 'package:decorated_flutter/decorated_flutter.dart';
import 'package:flutter/material.dart';

import 'preferred_async_builder.widget.dart';

class Toggleable extends StatelessWidget {
  const Toggleable({
    Key key,
    @required this.boolStream,
    @required this.builder,
    @required this.toggledBuilder,
    this.initialData = false,
  }) : super(key: key);

  final Stream<bool> boolStream;
  final WidgetBuilder builder;
  final WidgetBuilder toggledBuilder;
  final bool initialData;

  @override
  Widget build(BuildContext context) {
    return PreferredStreamBuilder<bool>(
      stream: boolStream,
      initialData: initialData,
      builder: (toggled) {
        if (toggled) {
          return toggledBuilder(context);
        } else {
          return builder(context);
        }
      },
    );
  }
}
