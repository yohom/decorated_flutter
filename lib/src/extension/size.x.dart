import 'dart:ui';

extension SizeX on Size {
  bool get isLandscape {
    return aspectRatio >= 1;
  }

  bool get isPortrait {
    return aspectRatio <= 1;
  }
}
