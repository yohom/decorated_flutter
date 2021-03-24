import 'dart:async';

import 'package:decorated_flutter/src/ui/ui.export.dart';
import 'package:flutter/material.dart';
import 'package:flutter/widgets.dart';

typedef Widget LoadingBuilder(BuildContext context, String loadingText);

extension FutureX<T> on Future<T> {
  static LoadingBuilder loadingWidgetBuilder;
  static Color backgroundColor;
  static bool loadingCancelable = false;

  Future<T> loading(
    BuildContext context, {
    bool cancelable,
    Duration timeout = const Duration(seconds: 60),
    String loadingText = '加载中..',
    Color backgroundColor,
  }) {
    final navigator = Navigator.of(context, rootNavigator: true);

    // 是被future pop的还是按返回键pop的
    bool popByFuture = true;

    final ThemeData theme = Theme.of(context);
    showGeneralDialog(
      context: context,
      pageBuilder: (
        BuildContext buildContext,
        Animation<double> animation,
        Animation<double> secondaryAnimation,
      ) {
        final Widget pageChild = Builder(
          builder: (context) {
            return WillPopScope(
              onWillPop: () async => cancelable ?? loadingCancelable,
              child: loadingWidgetBuilder != null
                  ? loadingWidgetBuilder(context, loadingText)
                  : LoadingWidget(),
            );
          },
        );
        return Builder(
          builder: (BuildContext context) {
            return theme != null
                ? Theme(data: theme, child: pageChild)
                : pageChild;
          },
        );
      },
      transitionDuration: const Duration(milliseconds: 150),
      barrierDismissible: cancelable ?? loadingCancelable,
      barrierLabel: 'Dismiss',
      barrierColor:
          backgroundColor ?? FutureX.backgroundColor ?? Colors.black54,
    ).whenComplete(() {
      // 1. 如果是返回键pop的, 那么设置成true, 这样future完成时就不会pop了
      // 2. 如果是future完成导致的pop, 那么这一行是没用任何作用的
      popByFuture = false;
    });

    this.timeout(timeout);

    whenComplete(() {
      // 由于showDialog会强制使用rootNavigator, 所以这里pop的时候也要用rootNavigator
      if (popByFuture) {
        navigator.pop();
      }
    });

    return this;
  }

  Future<T> apply<R>(FutureOr<R> onValue(T value), {Function onError}) async {
    await then(onValue, onError: onError);
    return this;
  }
}

extension StringFutureX on Future<String> {
  Future<String> operator +(String text) async {
    return (await this) + text;
  }
}
