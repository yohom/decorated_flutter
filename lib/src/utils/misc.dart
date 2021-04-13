import 'dart:math' as math;

import 'package:decorated_flutter/decorated_flutter.dart';
import 'package:dio/dio.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';

typedef void _HandlerErrorCallback(Object error);

@Deprecated('直接使用handleError即可')
_HandlerErrorCallback handle(BuildContext context) {
  return (Object error) => handleError(error);
}

void handleError(Object error) {
  L.d('handleError: $error');
  if (error is DioError) {
    String message = error.message;
    switch (error.type) {
      case DioErrorType.cancel:
        message = '取消请求';
        break;
      case DioErrorType.sendTimeout:
      case DioErrorType.connectTimeout:
      case DioErrorType.receiveTimeout:
        message = '网络连接超时，请重试';
        break;
      case DioErrorType.response:
        final statusCode = error.response.statusCode;
        if (statusCode >= 400 && statusCode <= 417) {
          message = '访问地址异常，请稍后重试 $statusCode';
        } else if (statusCode >= 500 && statusCode <= 505) {
          message = '服务器繁忙 $statusCode';
        }
        break;
      case DioErrorType.other:
        message = kReleaseMode ? '网络异常，请重试' : error.message;
        break;
      default:
        message = '网络异常，请重试';
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
