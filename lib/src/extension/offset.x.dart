import 'package:flutter/widgets.dart';

extension OffsetX on Offset {
  Offset clampX(double lowerLimit, double upperLimit) {
    return Offset(dx.clamp(lowerLimit, upperLimit), dy);
  }

  Offset clampY(double lowerLimit, double upperLimit) {
    return Offset(dx, dy.clamp(lowerLimit, upperLimit));
  }
}
