import 'dart:async';
import 'dart:io';
import 'dart:math' as math;

import 'package:decorated_flutter/src/misc/misc.export.dart';
import 'package:decorated_flutter/src/utils/utils.export.dart';
import 'package:dio/dio.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';

const _kDioOther = 100002;
const _kSocketException = 100001;

ValueChanged<Object>? handleCustomError;

dynamic handleError(Object error, [StackTrace? trace]) {
  L.e('[DECORATED_FLUTTER] handleError: $error, trace: $trace');
  final locale = gNavigatorKey.currentContext == null
      ? null
      : Localizations.localeOf(gNavigatorKey.currentContext!);
  final isEnglish = locale?.languageCode == 'en';
  if (error is DioException) {
    String? message = error.message;
    switch (error.type) {
      case DioExceptionType.cancel:
        message = isEnglish ? error.message : '取消请求';
        break;
      case DioExceptionType.sendTimeout:
      case DioExceptionType.connectionTimeout:
      case DioExceptionType.receiveTimeout:
        message = isEnglish ? error.message : '网络连接超时，请稍后重试';
        break;
      case DioExceptionType.badResponse:
        final statusCode = error.response?.statusCode;
        if (statusCode != null) {
          if (statusCode >= 400 && statusCode <= 417) {
            message = isEnglish ? error.message : '访问地址异常，请稍后重试 $statusCode';
          } else if (statusCode >= 500 && statusCode <= 505) {
            message = isEnglish ? error.message : '服务器繁忙 $statusCode';
          }
        }
        break;
      default:
        message = isEnglish ? error.message : '网络不给力，请稍后重试 $_kDioOther';
    }
    toast(message, error: true);
  } else if (error is String) {
    toast(error, error: true);
  } else if (error is SocketException) {
    toast(
      isEnglish ? error.message : '网络不给力，请稍后重试 $_kSocketException',
      error: true,
    );
  } else if (error is HttpException) {
    toast(
      isEnglish ? error.message : '网络不给力，请稍后重试 $_kSocketException',
      error: true,
    );
  } else if (error is BizException) {
    toast(error.message, error: true);
  } else if (error is TimeoutException) {
    toast('操作超时');
  } else if (error is PlatformException) {
    toast('${error.message ?? error.toString()} ${error.code}', error: true);
  } else {
    if (handleCustomError != null) {
      handleCustomError!(error);
    } else {
      toast(isEnglish ? 'Unknown Error' : '遇到未知错误 $error', error: true);
    }
  }
  throw error;
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
