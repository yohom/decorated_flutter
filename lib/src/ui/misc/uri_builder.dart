// 参考资料 https://github.dev/google/uri.dart
class UriBuilder {
  String fragment;
  String host;
  String path;
  int port;
  Map<String, String> queryParameters;
  String? scheme;
  String? userInfo;

  UriBuilder()
      : fragment = '',
        host = '',
        path = '',
        port = 0,
        queryParameters = <String, String>{};

  UriBuilder.fromUri(Uri uri)
      : fragment = uri.fragment,
        host = uri.host,
        path = uri.path,
        port = uri.port,
        queryParameters = Map<String, String>.from(uri.queryParameters),
        scheme = uri.scheme,
        userInfo = uri.userInfo;

  Uri build() {
    return Uri(
      fragment: _emptyToNull(fragment),
      host: _emptyToNull(host),
      path: _emptyToNull(path),
      port: port,
      queryParameters: queryParameters.isEmpty ? null : queryParameters,
      scheme: scheme ?? '',
      userInfo: userInfo ?? '',
    );
  }

  @override
  String toString() => build().toString();
}

String? _emptyToNull(String s) => s.isEmpty ? null : s;
