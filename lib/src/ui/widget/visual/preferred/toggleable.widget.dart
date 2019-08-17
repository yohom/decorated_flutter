import 'package:decorated_flutter/decorated_flutter.dart';
import 'package:decorated_flutter/src/annotation/wip.dart';
import 'package:flutter/material.dart';

import 'preferred_async_builder.widget.dart';

typedef Widget ToggleBuilder(BoolIO io);

@wip
class Toggleable extends StatelessWidget {
  const Toggleable({
    Key key,
    @required this.io,
    @required this.builder,
    @required this.toggledBuilder,
  }) : super(key: key);

  final BoolIO io;
  final WidgetBuilder builder;
  final WidgetBuilder toggledBuilder;

  @override
  Widget build(BuildContext context) {
    return PreferredStreamBuilder<bool>(
      stream: io.stream,
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

@wip
class DecoratedCheckBox extends StatelessWidget {
  const DecoratedCheckBox({
    Key key,
    @required this.io,
  }) : super(key: key);

  final BoolIO io;

  @override
  Widget build(BuildContext context) {
    return Toggleable(
      io: io,
      builder: (context) {
        return Checkbox(value: false, onChanged: io.add);
      },
      toggledBuilder: (context) {
        return Checkbox(value: true, onChanged: io.add);
      },
    );
  }
}
