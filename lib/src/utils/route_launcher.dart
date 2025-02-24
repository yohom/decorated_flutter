import 'package:decorated_flutter/src/utils/utils.export.dart';

/// 全局路由启动器
class RouteLauncher {
  RouteLauncher._();

  static final _launchMap = {};

  static void register(Map<String, Function> launchMap) {
    _launchMap.addAll(launchMap);
  }

  static Function? of(String path) {
    final result = _launchMap[path];
    if (result == null) {
      L.w('[DECORATED_FLUTTER] 未找到路径: $path 的启动器!');
    }
    return result;
  }
}
