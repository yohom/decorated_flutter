import 'dart:async';

import 'package:flutter/material.dart';
import 'package:framework/framework.dart';
import 'package:kiwi/kiwi.dart' as kiwi;

import '../ui/loading.widget.dart';

class Router {
  /// 导航
  static Future<T> navigate<T>(BuildContext context, Widget widget) {
    return Navigator.of(context).push<T>(
      MaterialPageRoute(
        builder: (context) => widget,
        settings: RouteSettings(name: widget.runtimeType.toString()),
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
  static void navigateReplace(BuildContext context, Widget widget) {
    Navigator.of(context).pushReplacement(
      MaterialPageRoute(
        builder: (context) => widget,
        settings: RouteSettings(name: widget.runtimeType.toString()),
      ),
    );
  }

  /// 提供BLoC的导航
  static void navigateBLoC<T extends BLoC>(
    BuildContext context,
    Widget widget,
  ) {
    Navigator.of(context).push(
      MaterialPageRoute(
        builder: (context) {
          return BLoCProvider<T>(
            bloc: kiwi.Container().resolve<T>(),
            child: widget,
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
