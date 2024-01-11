import 'dart:ui';

extension SizeX on Size {
  bool get isLandscape {
    return aspectRatio >= 1;
  }

  bool get isPortrait {
    return aspectRatio <= 1;
  }

  Size floor() {
    return Size(width.floor().toDouble(), height.floor().toDouble());
  }

  Size ceil() {
    return Size(width.ceil().toDouble(), height.ceil().toDouble());
  }

  Size round() {
    return Size(width.round().toDouble(), height.round().toDouble());
  }
}
