import 'package:decorated_flutter/decorated_flutter.dart';
import 'package:dio/dio.dart';

class HttpUtils {
  HttpUtils._();

  static String baseUrl;

  static void init(String url) {
    assert(isNotEmpty(url));
    baseUrl = url;
  }

  /// Map转成http请求参数的形式
  static String map2Url(Object data, {String path = ''}) {
    assert(isNotEmpty(baseUrl));

    String result = '';

    if (data is FormData) {
      data.entries.forEach((entry) {
        result = '${entry.key}=${entry.value}&$result';
      });
      result = '$baseUrl$path?$result';
    } else if (data is Map) {
      data.forEach((key, value) {
        result = '$key=$value&$result';
      });
      result = '$baseUrl$path?$result';
    }
    if (result.endsWith('&')) {
      result = result.substring(0, result.length - 1);
    }
    return Uri.encodeFull(result);
  }
}
