import 'dart:typed_data';

import 'package:flutter/rendering.dart';

extension RenderRepaintBoundaryX on RenderRepaintBoundary {
  Future<Uint8List> capture(double devicePixelRatio) async {
    return toImage(pixelRatio: devicePixelRatio)
        .then((image) => image.toByteData(format: .png))
        .then((byteData) => byteData!.buffer.asUint8List());
  }
}
