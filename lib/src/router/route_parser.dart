class RouteInfo {
  final String path;
  final Map<String, Object> arguments;

  RouteInfo(this.path, this.arguments);
}

RouteInfo parseRoute(String routeName) {
  //  分解出路径和参数
  List<String> pathAndArguments = routeName.split('?');
  // 获取路径
  String path = pathAndArguments[0];
  Map<String, Object> arguments;
  try {
    // 参数按&分解成键值对
    final argumentsList = pathAndArguments[1].split('&');
    // 每个键值对分解到Map中去
    argumentsList.forEach((argumentEntry) {
      final keyValue = argumentEntry.split('=');
      arguments[keyValue[0]] = keyValue[1];
    });
  } catch (e) {
    arguments = null;
  }
  return RouteInfo(path, arguments);
}
