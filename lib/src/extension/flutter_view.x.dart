import 'dart:ui';

extension FlutterViewX on FlutterView {
  Size get size => physicalSize / devicePixelRatio;
}
