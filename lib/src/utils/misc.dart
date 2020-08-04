import 'dart:async';
import 'dart:math' as math;

import 'package:decorated_flutter/decorated_flutter.dart';
import 'package:dio/dio.dart';
import 'package:flutter/material.dart';

typedef void _HandlerErrorCallback(Object error);

_HandlerErrorCallback handle(BuildContext context) {
  return (Object error) => handleError(context, error);
}

void handleError(BuildContext context, Object error) {
  if (error is DioError) {
    String message = error.message;
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
            message = '访问地址异常，请稍后重试 $statusCode';
          } else if (statusCode >= 500 && statusCode <= 505) {
            message = '服务器繁忙 $statusCode';
          }
          break;
        case DioErrorType.DEFAULT:
          message = error.message;
          break;
        default:
          message = error.message;
      }
    }
    toast(message);
  } else if (error is String) {
    toast(error);
  } else if (error is BizException) {
    toast(error.message);
  } else {
    toast(error.toString());
  }
}

/// 等待页
Future<T> loading<T>(
  BuildContext context,
  Future<T> futureTask, {
  bool cancelable = true,
}) {
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
  return futureTask.whenComplete(() {
    // 由于showDialog会强制使用rootNavigator, 所以这里pop的时候也要用rootNavigator
    if (popByFuture) {
      Navigator.of(context, rootNavigator: true).pop(context);
    }
  });
}

Color highContrast(Color input) {
  final grey = 0.2126 * math.pow(input.red / 255, 2.2) +
      0.7151 * math.pow(input.green / 255, 2.2) +
      0.0721 * math.pow(input.blue / 255, 2.2);
  Color output = Colors.black;
  if (grey <= 0.18) {
    output = Colors.white;
  }
  return output;
}

String enumName(enumValue) {
  var s = enumValue.toString();
  return s.substring(s.indexOf('.') + 1);
}

void clearFocus(BuildContext context) {
  FocusScope.of(context).requestFocus(FocusNode());
}
