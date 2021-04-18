import 'package:decorated_flutter/src/utils/utils.export.dart';
import 'package:flutter/material.dart';

class Repeat extends StatelessWidget {
  const Repeat({
    Key? key,
    required this.builder,
    required this.interval,
    this.backgroundColor = Colors.black,
  }) : super(key: key);

  final WidgetBuilder builder;
  final Duration interval;
  final Color backgroundColor;

  @override
  Widget build(BuildContext context) {
    return StreamBuilder<dynamic>(
      stream: Stream.periodic(interval, passthrough),
      builder: (context, _) => builder(context),
    );
  }
}
