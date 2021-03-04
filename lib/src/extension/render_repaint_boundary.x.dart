// @dart=2.9

import 'dart:typed_data';
import 'dart:ui';

import 'package:flutter/rendering.dart';

extension RenderRepaintBoundaryX on RenderRepaintBoundary {
  Future<Uint8List> capture(double devicePixelRatio) async {
    return toImage(pixelRatio: devicePixelRatio)
        .then((image) => image.toByteData(format: ImageByteFormat.png))
        .then((byteData) => byteData.buffer.asUint8List());
  }
}
