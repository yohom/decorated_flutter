import 'dart:async';

import 'package:flutter/material.dart';
import 'package:framework/framework.dart';
import 'package:kiwi/kiwi.dart' as kiwi;

import '../ui/loading.widget.dart';

typedef void InitAction<T extends BLoC>(T bloc);
typedef Widget _RouteBuilder(
  BuildContext context,
  Widget child,
  Animation<double> animation,
);

class Router {
  /// 导航
  static Future<T> navigate<T>(
    BuildContext context,
    Widget widget, {
    bool fullScreenDialog = false,
  }) {
    return Navigator.of(context).push<T>(
      MaterialPageRoute(
        fullscreenDialog: fullScreenDialog,
        builder: (context) => AutoCloseKeyboard(child: widget),
        settings: RouteSettings(name: widget.runtimeType.toString()),
      ),
    );
  }

  /// 自定义导航
  static Future<T> navigateCustom<T>(BuildContext context, PageRoute<T> route) {
    return Navigator.of(context).push<T>(route);
  }

  /// 自定义route的导航
  static Future<T> navigateRouteBuilder<T>({
    BuildContext context,
    _RouteBuilder builder,
    Widget child,
    bool fullScreenDialog = false,
    Duration transitionDuration = const Duration(milliseconds: 600),
    Color barrierColor,
    bool barrierDismissible = false,
    String barrierLabel,
  }) async {
    return Navigator.of(context).push<T>(
      PageRouteBuilder<Null>(
        pageBuilder: (
          BuildContext context,
          Animation<double> animation,
          Animation<double> secondaryAnimation,
        ) {
          return AnimatedBuilder(
            animation: animation,
            child: child,
            builder: (BuildContext context, Widget child) {
              return builder(context, child, animation);
            },
          );
        },
        transitionDuration: transitionDuration,
        barrierColor: barrierColor,
        barrierDismissible: barrierDismissible,
        barrierLabel: barrierLabel,
        settings: RouteSettings(name: builder.runtimeType.toString()),
      ),
    );
  }

  /// 通过bottom sheet显示新界面, 通过这种方式, 新的界面会在父界面的节点下面, 而不是像
  /// [navigate]系列一样和父界面同级.
  static PersistentBottomSheetController<T> navigateBottomSheet<T>(
    BuildContext context,
    Widget widget,
  ) {
    return showBottomSheet(context: context, builder: (context) => widget);
  }

  /// 不保留源页面的跳转
  static void navigateReplace(
    BuildContext context,
    Widget widget, {
    bool fullScreenDialog = false,
  }) {
    Navigator.of(context).pushReplacement(
      MaterialPageRoute(
        fullscreenDialog: fullScreenDialog,
        builder: (context) => widget,
        settings: RouteSettings(name: widget.runtimeType.toString()),
      ),
    );
  }

  /// 提供BLoC的导航
  static Future<R> navigateWithBLoC<B extends BLoC, R>(
    BuildContext context,
    Widget widget, {
    InitAction<B> init,
    bool fullScreenDialog = false,
  }) {
    final bloc = kiwi.Container().resolve<B>();
    return Navigator.of(context).push<R>(
      MaterialPageRoute(
        fullscreenDialog: fullScreenDialog,
        builder: (context) {
          return BLoCProvider<B>(
            bloc: bloc,
            child: AutoCloseKeyboard(
              child: Builder(
                builder: (context) {
                  if (init != null) init(bloc);
                  return widget;
                },
              ),
            ),
          );
        },
        settings: RouteSettings(name: widget.runtimeType.toString()),
      ),
    );
  }

  /// 退出当前页
  static void pop<T>(BuildContext context, [T data]) {
    Navigator.of(context).pop<T>(data);
  }

  /// 退出到目标页
  static void popTo<T>(BuildContext context, Type routeType) {
    Navigator.of(context).popUntil(
      (route) => route.settings.name == routeType.toString(),
    );
  }

  static void pushAndClearAll(BuildContext context, Widget widget) {
    Navigator.of(context).pushAndRemoveUntil(
      MaterialPageRoute(
        builder: (context) => widget,
        settings: RouteSettings(name: widget.runtimeType.toString()),
      ),
      (route) => false,
    );
  }

  /// 等待页
  static Future<T> loading<T>(BuildContext context, Future<T> futureTask) {
    showDialog(
      context: context,
      builder: (context) => LoadingWidget(),
      barrierDismissible: false,
    );
    return futureTask.whenComplete(() {
      pop(context);
    });
  }
}
