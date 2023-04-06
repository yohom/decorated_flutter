import 'package:dio/dio.dart';

/// 节流拦截器
///
/// 以下内容由gpt生成, 但是感觉还是没有达到我想要的效果, 最理想的效果应该是直接合并相同的请求, **先暂时不要使用这个拦截器**
class ThrottleInterceptor extends Interceptor {
  final Duration _duration;
  RequestOptions? _lastOptions;
  DateTime? _lastRequestTime;

  ThrottleInterceptor(this._duration);

  @override
  void onRequest(
    RequestOptions options,
    RequestInterceptorHandler handler,
  ) async {
    if (_lastOptions != null &&
        _isSameRequest(options, _lastOptions!) &&
        _lastRequestTime != null &&
        DateTime.now().difference(_lastRequestTime!) < _duration) {
      // 请求完全一致且时间间隔小于指定时间，则不发送请求
      return;
    }
    _lastOptions = options;
    _lastRequestTime = DateTime.now();
    super.onRequest(options, handler);
  }

  bool _isSameRequest(RequestOptions a, RequestOptions b) {
    return a.method.toLowerCase() == b.method.toLowerCase() &&
        a.path == b.path &&
        a.queryParameters == b.queryParameters &&
        a.data == b.data;
  }
}
