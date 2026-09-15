import 'package:flutter/widgets.dart';

extension TextX on Text {
  Text operator +(Object other) {
    final otherSpan = switch (other) {
      final Text text => _inlineSpan(text),
      final InlineSpan span => span,
      _ => throw ArgumentError.value(
          other,
          'other',
          'must be a Text or InlineSpan',
        ),
    };

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

InlineSpan _inlineSpan(Text text) {
  final span = text.textSpan;
  return TextSpan(
    text: text.data,
    style: text.style,
    locale: text.locale,
    semanticsLabel: text.semanticsLabel,
    semanticsIdentifier: text.semanticsIdentifier,
    children: span == null ? null : [span],
  );
}
