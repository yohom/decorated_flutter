import 'package:decorated_flutter/src/ui/ui.export.dart';
import 'package:flutter/material.dart';
import 'package:flutter/widgets.dart';

extension FutureX<T> on Future<T> {
  Future<T> loading(BuildContext context, {bool cancelable = false}) {
    // 是被future pop的还是按返回键pop的
    bool popByFuture = true;

    showDialog(
      context: context,
      builder: (context) {
        return WillPopScope(
          onWillPop: () async => cancelable,
          child: LoadingWidget(),
        );
      },
      barrierDismissible: cancelable,
    ).whenComplete(() {
      // 1. 如果是返回键pop的, 那么设置成true, 这样future完成时就不会pop了
      // 2. 如果是future完成导致的pop, 那么这一行是没用任何作用的
      popByFuture = false;
    });

    // 防止上游同步返回Future.error, 导致showDialog还没弹出, 这里就已经调用Complete了
    WidgetsBinding.instance.addPostFrameCallback((_) => whenComplete(() {
          // 由于showDialog会强制使用rootNavigator, 所以这里pop的时候也要用rootNavigator
          if (popByFuture) {
            Navigator.of(context, rootNavigator: true).pop(this);
          }
        }));

    return this;
  }
}
