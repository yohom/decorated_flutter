import 'package:flutter/widgets.dart';

extension TextX on Text {
  Text operator +(InlineSpan otherSpan) {
    return Text.rich(
      TextSpan(
        children: [
          textSpan ?? TextSpan(text: data),
          otherSpan,
        ],
      ),
      key: key,
      style: style,
      textDirection: textDirection,
      locale: locale,
      softWrap: softWrap,
      overflow: overflow,
      textScaleFactor: textScaleFactor,
      textScaler: textScaler,
      maxLines: maxLines,
      textAlign: textAlign,
      strutStyle: strutStyle,
      semanticsLabel: semanticsLabel,
      semanticsIdentifier: semanticsIdentifier,
      textWidthBasis: textWidthBasis,
      textHeightBehavior: textHeightBehavior,
      selectionColor: selectionColor,
    );
  }
}
