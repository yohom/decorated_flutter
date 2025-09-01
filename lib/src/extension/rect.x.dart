import 'dart:ui';

extension RectX on Rect {
  /// 对矩形的坐标和大小进行缩放
  Rect scale(double factor) {
    return Rect.fromLTWH(
      left * factor,
      top * factor,
      width * factor,
      height * factor,
    );
  }
}
