import 'package:flutter/widgets.dart';

extension ColorDecoratedExtension on Color {
  String hexString({bool withAlpha = true}) {
    final hexAlpha = '#${alpha.toRadixString(16).padLeft(2, '0')}';
    final hexColor = '${red.toRadixString(16).padLeft(2, '0')}'
        '${green.toRadixString(16).padLeft(2, '0')}'
        '${blue.toRadixString(16).padLeft(2, '0')}';
    return withAlpha ? '$hexAlpha$hexColor' : hexColor;
  }
}
