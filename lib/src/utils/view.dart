import 'dart:async';

import 'package:decorated_flutter/decorated_flutter.dart';
import 'package:decorated_flutter/src/utils/enums.dart';
import 'package:flushbar/flushbar.dart';
import 'package:flutter/material.dart';

const _duration = 2000;

Future showFlushBar(
  BuildContext context,
  String content, {
  String title,
  Color color,
  ErrorLevel errorLevel = ErrorLevel.none,
  position = FlushbarPosition.BOTTOM,
  bool isExit = false, // show完了是否退出本页
  String exitTo, // 退出到对应页面
  Duration duration = const Duration(milliseconds: _duration),
}) {
  L.p('showFlushBar: $content');
  if (color == null) {
    switch (errorLevel) {
      case ErrorLevel.none:
        color = Theme.of(context).primaryColor;
        break;
      case ErrorLevel.warn:
        color = Colors.yellowAccent;
        break;
      case ErrorLevel.severe:
      case ErrorLevel.fatal:
        color = Colors.red;
        break;
    }
  }

  return Flushbar(
    title: title,
    message: content,
    flushbarPosition: position,
    backgroundColor: color,
    duration: duration,
    flushbarStyle: FlushbarStyle.GROUNDED,
  ).show(context).then((_) {
    if (isNotEmpty(exitTo)) {
      Navigator.popUntil(context, ModalRoute.withName(exitTo));
    } else if (isExit) {
      Navigator.pop(context);
    }
  });
}

/// 显示信息底层方法, 当需要动态选择是错误还是正常信息时, 调用这个方法
@Deprecated('使用[showFlushBar]代替, 因为FlushBar没有Scaffold限制, 并且定制程度更高')
Future<SnackBarClosedReason> showMessage(
  BuildContext context,
  String content, {
  ErrorLevel errorLevel = ErrorLevel.none,
  bool isExit = false, // show完了是否退出本页
  String exitTo, // 退出到对应页面
  Duration duration = const Duration(milliseconds: _duration),
}) {
  Color color;
  switch (errorLevel) {
    case ErrorLevel.none:
      break;
    case ErrorLevel.warn:
      color = Colors.yellowAccent;
      break;
    case ErrorLevel.severe:
    case ErrorLevel.fatal:
      color = Colors.red;
      break;
  }
  return Scaffold.of(context)
      .showSnackBar(
        SnackBar(
          content: Text(content),
          backgroundColor: color,
          duration: duration,
        ),
      )
      .closed
      .then((_) {
    if (isNotEmpty(exitTo)) {
      Navigator.popUntil(context, ModalRoute.withName(exitTo));
    } else if (isExit) {
      Navigator.pop(context);
    }
  });
}

/// 显示错误信息
Future showError(
  BuildContext context,
  String content, {
  String title,
  position = FlushbarPosition.BOTTOM,
  bool isExit = false, // show完了是否退出本页
  String exitTo, // 退出到对应页面
  Duration duration = const Duration(milliseconds: _duration),
}) {
  return showFlushBar(
    context,
    content,
    title: title,
    position: position,
    errorLevel: ErrorLevel.severe,
    isExit: isExit,
    exitTo: exitTo,
    duration: duration,
  );
}

/// 显示普通信息
Future showInfo(
  BuildContext context,
  String content, {
  String title,
  position = FlushbarPosition.BOTTOM,
  bool isExit = false, // show完了是否退出本页
  String exitTo, // 退出到对应页面
  Duration duration = const Duration(milliseconds: _duration),
}) {
  return showFlushBar(
    context,
    content,
    title: title,
    position: position,
    errorLevel: ErrorLevel.none,
    isExit: isExit,
    exitTo: exitTo,
    duration: duration,
  );
}

/// 显示警告信息
Future showWarn(
  BuildContext context,
  String content, {
  String title,
  position = FlushbarPosition.BOTTOM,
  bool isExit = false, // show完了是否退出本页
  String exitTo, // 退出到对应页面
  Duration duration = const Duration(milliseconds: _duration),
}) {
  return showFlushBar(
    context,
    content,
    title: title,
    position: position,
    errorLevel: ErrorLevel.warn,
    isExit: isExit,
    exitTo: exitTo,
    duration: duration,
  );
}
