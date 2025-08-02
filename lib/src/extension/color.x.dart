import 'package:flutter/widgets.dart';

extension ColorDecoratedExtension on Color {
  @Deprecated('使用hexARGB或hexRGBA')
  String hexString({bool withAlpha = true}) {
    final hexAlpha = '#${alpha.toRadixString(16).padLeft(2, '0')}';
    final hexColor = '${red.toRadixString(16).padLeft(2, '0')}'
        '${green.toRadixString(16).padLeft(2, '0')}'
        '${blue.toRadixString(16).padLeft(2, '0')}';
    return withAlpha ? '$hexAlpha$hexColor' : hexColor;
  }

  String hexARGB() {
    return '${alpha.toRadixString(16).padLeft(2, '0')}'
        '${red.toRadixString(16).padLeft(2, '0')}'
        '${green.toRadixString(16).padLeft(2, '0')}'
        '${blue.toRadixString(16).padLeft(2, '0')}';
  }

  String hexRGBA() {
    return '${red.toRadixString(16).padLeft(2, '0')}'
        '${green.toRadixString(16).padLeft(2, '0')}'
        '${blue.toRadixString(16).padLeft(2, '0')}'
        '${alpha.toRadixString(16).padLeft(2, '0')}';
  }

  String hexRGB() {
    return '${red.toRadixString(16).padLeft(2, '0')}'
        '${green.toRadixString(16).padLeft(2, '0')}'
        '${blue.toRadixString(16).padLeft(2, '0')}';
  }

  /// 形如`rgb(255, 0, 0)`
  String rgb() {
    return 'rgb($red, $green, $blue)';
  }

  /// 形如`rgba(255, 0, 0, 0.5)`
  String rgba() {
    return 'rgba($red, $green, $blue, $a)';
  }
}
