import 'package:flutter/widgets.dart';

extension WidgetX on Widget {
  Text operator +(InlineSpan otherSpan) {
    final imageSpan = WidgetSpan(child: this);
    return Text.rich(
      TextSpan(
        children: [
          imageSpan,
          otherSpan,
        ],
      ),
    );
  }
}
