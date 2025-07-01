import 'package:flutter/material.dart';

extension PageControllerX on PageController {
  bool get isChangingPage {
    return hasClients && page?.toInt() != page;
  }

  int get pageIndex {
    // 读取page时, positions长度必须是1
    if (positions.length != 1) return 0;

    return page?.toInt() ?? 0;
  }
}
