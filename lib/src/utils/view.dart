import 'dart:async';

import 'package:flutter/material.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:framework/framework.dart';


///
/// 显示信息底层方法, 当需要动态选择是错误还是正常信息时, 调用这个方法
///
Future<SnackBarClosedReason> showMessage(
  BuildContext context,
  String content, {
  bool isError = true, // 是否错误消息
  bool isExit = false, // show完了是否退出本页
}) {
  L.d('messge: $content');
  return Scaffold.of(context)
      .showSnackBar(
        SnackBar(
          content: Text(content),
          backgroundColor: isError ? Colors.red : Colors.blueAccent,
          duration: Duration(seconds: 2),
        ),
      )
      .closed
      .then((_) {
    if (isExit) Router.pop(context);
  });
}

///
/// 显示错误信息
///
Future<SnackBarClosedReason> showError(
  BuildContext context,
  String content, {
  bool isExit = false, // show完了是否退出本页
}) {
  L.d('messge: $content');
  return showMessage(context, content, isError: true, isExit: isExit);
}

///
/// 显示普通信息
///
Future<SnackBarClosedReason> showInfo(
  BuildContext context,
  String content, {
  bool isExit = false, // show完了是否退出本页
}) {
  L.d('messge: $content');
  return showMessage(context, content, isError: false, isExit: isExit);
}

///
/// 显示警告信息
///
Future<SnackBarClosedReason> showWarn(
  BuildContext context,
  String content, {
  bool isExit = false, // show完了是否退出本页
}) {
  L.d('messge: $content');
  return Scaffold.of(context)
      .showSnackBar(
        SnackBar(
          content: Text(content),
          backgroundColor: Colors.yellowAccent,
          duration: Duration(seconds: 2),
        ),
      )
      .closed
      .then((_) {
    if (isExit) Router.pop(context);
  });
}

///
/// 无差别全局显示toast
///
void showToast(
  String content, {
  bool isError = false,
  ToastGravity gravity = ToastGravity.BOTTOM,
}) {
  Fluttertoast.showToast(
    msg: content,
    gravity: gravity,
    bgcolor: isError ? '#FFFF0000' : '#FF999999',
    textcolor: '#FFFFFFFF',
  );
}
