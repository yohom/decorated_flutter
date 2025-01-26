import 'dart:ui';

import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:flutter/rendering.dart';

extension GlobalKeyX on GlobalKey {
  Future<Uint8List?> capture() async {
    final box = (currentContext?.findRenderObject() as RenderRepaintBoundary?);
    if (box == null) return null;

    if (kDebugMode) {
      int attempts = 0;
      while (box.debugNeedsPaint && attempts < 10) {
        await Future.delayed(const Duration(milliseconds: 16));
        attempts++;
      }
    } else {
      await Future.delayed(const Duration(milliseconds: 32));
    }

    return box
        .toImage(pixelRatio: window.devicePixelRatio)
        .then((image) => image.toByteData(format: ImageByteFormat.png))
        .then((byteData) => byteData?.buffer.asUint8List())
        .catchError((_) => null);
  }
}
