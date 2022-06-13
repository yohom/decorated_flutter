import 'package:flutter/material.dart';

extension PageControllerX on PageController {
  bool get isChangingPage {
    return hasClients && page?.toInt() != page;
  }

  int get pageIndex {
    return page?.toInt() ?? 0;
  }
}
