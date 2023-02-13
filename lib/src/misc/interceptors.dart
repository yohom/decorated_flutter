import 'package:dio/dio.dart';

/// 节流拦截器
class ThrottleInterceptor extends Interceptor {
  DateTime? _lastRequestTime;

  @override
  void onRequest(RequestOptions options, RequestInterceptorHandler handler) {
    final path = options.path;
    final data = options.data;
    _lastRequestTime = DateTime.now();
  }
}
