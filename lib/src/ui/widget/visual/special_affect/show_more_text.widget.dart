import 'package:flutter/material.dart';

class ShowMoreText extends StatelessWidget {
  const ShowMoreText(
    this.text, {
    super.key,
    this.maxLines = 1,
    this.style,
    this.showMoreStyle,
    this.textAlign,
    this.overflow = TextOverflow.ellipsis,
    this.popupMenuTheme = const PopupMenuThemeData(),
  });

  final String text;
  final int maxLines;
  final TextStyle? style;
  final TextStyle? showMoreStyle;
  final TextAlign? textAlign;
  final TextOverflow overflow;
  final PopupMenuThemeData popupMenuTheme;

  @override
  Widget build(BuildContext context) {
    return Theme(
      data: Theme.of(context).copyWith(popupMenuTheme: popupMenuTheme),
      child: PopupMenuButton(
        child: Text(
          text,
          style: style,
          maxLines: maxLines,
          overflow: overflow,
          textAlign: textAlign,
        ),
        itemBuilder: (context) {
          return [
            PopupMenuItem(
              child: Text(text, style: showMoreStyle),
            ),
          ];
        },
      ),
    );
  }
}
