import 'package:dio/dio.dart';

class DioLoggerFilter {
  DioLoggerFilter({this.whitelist, this.blacklist})
    : _patterns = (whitelist ?? blacklist ?? const <String>[]).map((pattern) {
        final expression = pattern.split('*').map(RegExp.escape).join('.*');
        return RegExp('^$expression\$');
      }).toList() {
    if (whitelist != null && blacklist != null) {
      throw ArgumentError('Dio 日志过滤只能配置白名单或黑名单');
    }
  }

  final List<String>? whitelist;
  final List<String>? blacklist;
  final List<RegExp> _patterns;

  bool shouldLog(RequestOptions options) {
    final matches = _patterns.any(
      (pattern) => pattern.hasMatch(options.uri.path),
    );
    return whitelist == null ? !matches : matches;
  }

  Interceptor wrap(Interceptor logger) {
    return InterceptorsWrapper(
      onRequest: (options, handler) {
        if (shouldLog(options)) {
          logger.onRequest(options, handler);
        } else {
          handler.next(options);
        }
      },
      onResponse: (response, handler) {
        if (shouldLog(response.requestOptions)) {
          logger.onResponse(response, handler);
        } else {
          handler.next(response);
        }
      },
      onError: (error, handler) {
        if (shouldLog(error.requestOptions)) {
          logger.onError(error, handler);
        } else {
          handler.next(error);
        }
      },
    );
  }
}
