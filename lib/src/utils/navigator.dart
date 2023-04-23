import 'package:decorated_flutter/decorated_flutter.dart';
import 'package:flutter/widgets.dart';

const _kNoNav = '未找到Navigator, 请先使用gNavigator设置为MaterialApp的navigatorKey!';

/// push一个路由
///
/// [query]是一个只有字符串键值对的Map, 直接拼接在路径后面, 这样可以在web环境下保持状态
/// [body]可以为任意对象, 但是不能在不同会话之间保持(比如web端的刷新)
Future<T?> pushRoute<T>(
  String path, {
  Map<String, String?>? query,
  Map<String, Object?>? body,
  BuildContext? context,
}) {
  final navigator = gNavigatorKey.currentState ?? context?.navigator;
  if (navigator == null) throw _kNoNav;

  return navigator.pushNamed<T>(_routeName(path, query), arguments: body);
}

/// 替换一个路由
///
/// [query]是一个只有字符串键值对的Map, 直接拼接在路径后面, 这样可以在web环境下保持状态
/// [body]可以为任意对象, 但是不能在不同会话之间保持(比如web端的刷新)
Future<T?> replaceRoute<T extends Object?, TO extends Object?>(
  String path, {
  Map<String, String?>? query,
  Map<String, Object?>? body,
  BuildContext? context,
}) {
  final navigator = gNavigatorKey.currentState ?? context?.navigator;
  if (navigator == null) throw _kNoNav;

  return navigator.pushReplacementNamed<T, TO>(_routeName(path, query),
      arguments: body);
}

/// push一个路由并弹出指定路由
///
/// [query]是一个只有字符串键值对的Map, 直接拼接在路径后面, 这样可以在web环境下保持状态
/// [body]可以为任意对象, 但是不能在不同会话之间保持(比如web端的刷新)
Future<T?> pushRemoveUntil<T extends Object?, TO extends Object?>(
  String path,
  RoutePredicate predicate, {
  Map<String, String?>? query,
  Map<String, Object?>? body,
  BuildContext? context,
}) {
  final navigator = gNavigatorKey.currentState ?? context?.navigator;
  if (navigator == null) throw _kNoNav;

  return navigator.pushNamedAndRemoveUntil(
    _routeName(path, query),
    predicate,
    arguments: body,
  );
}

String _routeName(String path, Map<String, String?>? query) {
  final routeName = StringBuffer(path);
  if (query != null) {
    routeName.write('?');
    routeName.write(query.entries
        .where((e) => e.value != null)
        .map((e) => '${e.key}=${e.value}')
        .join('&'));
  }

  return routeName.toString();
}
