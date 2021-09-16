import 'dart:async';

import 'package:decorated_flutter/src/ui/ui.export.dart';
import 'package:decorated_flutter/src/utils/objects.dart';
import 'package:decorated_flutter/src/utils/utils.export.dart';
import 'package:flutter/material.dart';
import 'package:flutter/widgets.dart';

typedef Widget LoadingBuilder(BuildContext context, String loadingText);

extension FutureX<T> on Future<T> {
  static LoadingBuilder? loadingWidgetBuilder;
  static Color? backgroundColor;
  static bool loadingCancelable = false;
  static String defaultLoadingText = '加载中...';

  Future<T> loading({
    bool? cancelable,
    Duration timeLimit = const Duration(seconds: 60),
    String? loadingText,
    Color? backgroundColor,
  }) {
    final context = gNavigatorKey.currentContext;
    if (context == null) {
      throw '请在MaterialApp/CupertinoApp中设置navigatorKey为gNavigatorKey';
    }

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
              child: loadingWidgetBuilder?.call(
                    context,
                    loadingText ?? defaultLoadingText,
                  ) ??
                  LoadingWidget(),
            );
          },
        );
        return Builder(
          builder: (context) {
            return Theme(data: theme, child: pageChild);
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

    return timeout(timeLimit).whenComplete(() {
      if (popByFuture && navigator.canPop()) {
        navigator.pop();
      }
    });
  }

  /// apply一个回调, 然后返回当前对象
  Future<T> apply<R>(FutureOr<R> onValue(T value), {Function? onError}) async {
    await then(onValue, onError: onError);
    return this;
  }

  /// 延迟一段时间
  Future<T> delay(Duration duration) async {
    return then((value) async {
      await Future.delayed(duration);
      return value;
    });
  }
}

extension StringFutureX on Future<String> {
  Future<String> operator +(String text) async {
    return (await this) + text;
  }
}
