import 'package:flutter/material.dart';

class ShowMoreText extends StatelessWidget {
  const ShowMoreText(
    this.text, {
    Key? key,
    this.maxLines = 1,
    this.style,
    this.showMoreStyle,
    this.overflow = TextOverflow.ellipsis,
    this.popupMenuTheme = const PopupMenuThemeData(),
  }) : super(key: key);

  final String text;
  final int maxLines;
  final TextStyle? style;
  final TextStyle? showMoreStyle;
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
