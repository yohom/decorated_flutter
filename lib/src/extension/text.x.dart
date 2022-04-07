import 'package:flutter/widgets.dart';

extension TextX on Text {
  Text operator +(InlineSpan otherSpan) {
    final span = textSpan as TextSpan?;
    return Text.rich(
      TextSpan(
        text: span?.text ?? data,
        style: style,
        children: [
          ...?span?.children,
          otherSpan,
        ],
      ),
      style: style,
      softWrap: softWrap,
      overflow: overflow,
      maxLines: maxLines,
      textAlign: textAlign,
      strutStyle: strutStyle,
    );
  }
}
