import 'dart:ui';

import 'package:decorated_flutter/src/utils/logger/logger.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:flutter/rendering.dart';

extension GlobalKeyX on GlobalKey {
  Future<Uint8List?> capture({double? pixelRatio}) async {
    try {
      final box =
          (currentContext?.findRenderObject() as RenderRepaintBoundary?);
      if (box == null) throw '未找到目标RenderObject';

      if (kDebugMode) {
        int attempts = 0;
        while (box.debugNeedsPaint && attempts < 10) {
          await Future.delayed(const Duration(milliseconds: 16));
          attempts++;
        }
      } else {
        await Future.delayed(const Duration(milliseconds: 32));
      }

      final image =
          await box.toImage(pixelRatio: pixelRatio ?? window.devicePixelRatio);
      final byteData = await image.toByteData(format: ImageByteFormat.png);
      final imageData = byteData?.buffer.asUint8List();

      return imageData;
    } catch (e) {
      L.e('[DECORATED_FLUTTER] 尝试截图失败: $e');
      return null;
    }
  }
}
