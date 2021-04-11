import 'dart:io';

import 'package:flutter/material.dart';

class AdaptiveWillPopScope extends StatelessWidget {
  const AdaptiveWillPopScope({
    Key key,
    @required this.onWillPop,
    @required this.child,
  })  : assert(onWillPop != null, child != null),
        super(key: key);

  final Widget child;

  final bool Function() onWillPop;

  @override
  Widget build(BuildContext context) {
    Widget result = child;

    final willPop = onWillPop();
    // 如果允许弹出, ios端则直接返回, android端再包一层
    if (willPop) {
      if (Platform.isIOS) {
        return result;
      } else if (Platform.isAndroid) {
        return WillPopScope(child: result, onWillPop: () async => willPop);
      } else {
        throw '为支持的平台';
      }
    }
    // 如果不允许弹出, 则直接包一层WillPopScope即可
    else {
      return WillPopScope(child: result, onWillPop: () async => willPop);
    }
  }
}
