import 'package:flutter/material.dart';

/// 这里的*Flat*并不是视觉上的*Flat*, 只是把[TextStyle]里的参数提取到[Text]的构造器里,
/// 减少层级
class FlatText extends StatelessWidget {
  //region Text
  final String data;

  final TextSpan textSpan;

  final TextAlign textAlign;

  final TextDirection textDirection;

  final Locale locale;

  final bool softWrap;

  final TextOverflow overflow;

  final double textScaleFactor;

  final int maxLines;

  final String semanticsLabel;
  //endregion

  //region TextStyle
  final bool inherit;

  final Color color;

  final String fontFamily;

  final double fontSize;

  final FontWeight fontWeight;

  final FontStyle fontStyle;

  final double letterSpacing;

  final double wordSpacing;

  final TextBaseline textBaseline;

  final double height;

  final Paint foreground;

  final Paint background;

  final TextDecoration decoration;

  final Color decorationColor;

  final TextDecorationStyle decorationStyle;

  final String debugLabel;
  //endregion

  const FlatText(
    this.data, {
    Key key,
    this.textSpan,
    this.textAlign,
    this.textDirection,
    this.locale,
    this.softWrap,
    this.overflow,
    this.textScaleFactor,
    this.maxLines,
    this.semanticsLabel,
    this.inherit = true,
    this.color,
    this.fontFamily,
    this.fontSize,
    this.fontWeight,
    this.fontStyle,
    this.letterSpacing,
    this.wordSpacing,
    this.textBaseline,
    this.height,
    this.foreground,
    this.background,
    this.decoration,
    this.decorationColor,
    this.decorationStyle,
    this.debugLabel,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Text(
      data,
      key: key,
      style: TextStyle(
        inherit: inherit,
        color: color,
        fontSize: fontSize,
        fontWeight: fontWeight,
        fontStyle: fontStyle,
        letterSpacing: letterSpacing,
        wordSpacing: wordSpacing,
        textBaseline: textBaseline,
        height: height,
        locale: locale,
        foreground: foreground,
        background: background,
        decoration: decoration,
        decorationColor: decorationColor,
        decorationStyle: decorationStyle,
        debugLabel: debugLabel,
        fontFamily: fontFamily,
      ),
      textAlign: textAlign,
      textDirection: textDirection,
      locale: locale,
      softWrap: softWrap,
      overflow: overflow,
      textScaleFactor: textScaleFactor,
      maxLines: maxLines,
      semanticsLabel: semanticsLabel,
    );
  }
}
