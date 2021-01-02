import 'package:flutter/widgets.dart';

extension WidgetX on Widget {
  Text operator +(InlineSpan otherSpan) {
    final widgetSpan = WidgetSpan(child: this);
    return Text.rich(
      TextSpan(children: [widgetSpan, otherSpan]),
      softWrap: true,
      overflow: TextOverflow.ellipsis,
    );
  }
}
