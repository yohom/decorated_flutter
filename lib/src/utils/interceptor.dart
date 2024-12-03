import 'dart:async';

import 'package:dio/dio.dart';

class DebounceInterceptor extends Interceptor {
  final Map<String, Timer> _requestTimers = {}; // 记录请求的防抖状态
  final Duration debounceDuration; // 防抖间隔（毫秒）

  DebounceInterceptor({
    this.debounceDuration = const Duration(milliseconds: 256),
  });

  @override
  void onRequest(RequestOptions options, RequestInterceptorHandler handler) {
    final key = _generateRequestKey(options);

    if (_requestTimers.containsKey(key)) {
      // 如果请求在防抖间隔内，则取消新请求
      handler.reject(
        DioException(
          requestOptions: options,
          type: DioExceptionType.cancel,
          error: 'Debounced request: $key',
        ),
      );
      return;
    }

    // 如果没有重复请求，则允许请求并设置防抖计时器
    _requestTimers[key] = Timer(debounceDuration, () {
      _requestTimers.remove(key); // 防抖时间过后移除记录
    });

    super.onRequest(options, handler);
  }

  @override
  void onResponse(Response response, ResponseInterceptorHandler handler) {
    final key = _generateRequestKey(response.requestOptions);
    _requestTimers.remove(key); // 请求完成后移除记录
    super.onResponse(response, handler);
  }

  @override
  void onError(DioException err, ErrorInterceptorHandler handler) {
    final key = _generateRequestKey(err.requestOptions);
    _requestTimers.remove(key); // 请求失败后移除记录
    super.onError(err, handler);
  }

  /// 根据请求的 URL 和参数生成唯一标识
  String _generateRequestKey(RequestOptions options) {
    return '${options.method}-${options.uri.toString()}';
  }
}
