import 'package:flutter/widgets.dart';

extension ImageX on Image {
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
