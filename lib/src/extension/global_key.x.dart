// @dart=2.9

import 'dart:typed_data';
import 'dart:ui';

import 'package:flutter/material.dart';
import 'package:flutter/rendering.dart';

extension GlobalKeyX on GlobalKey {
  Future<Uint8List> capture() {
    return (currentContext.findRenderObject() as RenderRepaintBoundary)
        .toImage(pixelRatio: MediaQuery.of(currentContext).devicePixelRatio)
        .then((image) => image.toByteData(format: ImageByteFormat.png))
        .then((byteData) => byteData.buffer.asUint8List());
  }
}
