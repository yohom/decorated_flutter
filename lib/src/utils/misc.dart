import 'package:decorated_flutter/decorated_flutter.dart';
import 'package:dio/dio.dart';
import 'package:flutter/material.dart';

void handleError(BuildContext context, Object error) {
  if (error is DioError) {
    String message = '网络异常, 请检查网络设置';
    if (error.response != null) {
      switch (error.type) {
        case DioErrorType.CANCEL:
          message = '取消请求';
          break;
        case DioErrorType.CONNECT_TIMEOUT:
          message = '请求超时';
          break;
        case DioErrorType.RECEIVE_TIMEOUT:
          message = '接收超时';
          break;
        case DioErrorType.RESPONSE:
          final statusCode = error.response.statusCode;
          if (statusCode >= 400 && statusCode <= 417) {
            message = '访问地址异常，请稍后重试';
          } else if (statusCode >= 500 && statusCode <= 505) {
            message = '服务器繁忙';
          }
          break;
        case DioErrorType.DEFAULT:
          message = '网络异常, 请检查网络设置';
          break;
        default:
          message = '网络异常, 请检查网络设置';
      }
    }
    showError(context, message);
  } else if (error is String) {
    showError(context, error);
  } else {
    showError(context, error.toString());
  }
}

/// 等待页
Future<T> loading<T>(BuildContext context, Future<T> futureTask) {
  // 是被future pop的还是按返回键pop的
  bool popByFuture = true;

  showDialog(
    context: context,
    builder: (context) {
      return WillPopScope(onWillPop: () async => false, child: LoadingWidget());
    },
    barrierDismissible: false,
  ).whenComplete(() {
    // 1. 如果是返回键pop的, 那么设置成true, 这样future完成时就不会pop了
    // 2. 如果是future完成导致的pop, 那么这一行是没用任何作用的
    popByFuture = false;
  });
  return futureTask.whenComplete(() {
    // 由于showDialog会强制使用rootNavigator, 所以这里pop的时候也要用rootNavigator
    if (popByFuture) {
      Navigator.of(context, rootNavigator: true).pop(context);
    }
  });
}
