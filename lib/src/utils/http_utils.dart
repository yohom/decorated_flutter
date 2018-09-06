import 'package:dio/dio.dart';

class Convert {
  ///
  /// Map转成http请求参数的形式
  ///
  static String map2Url(
    Object data, {
    String baseUrl = kBaseUrl,
    String path = kPath,
  }) {
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
    return Uri.encodeFull(result);
  }
}
