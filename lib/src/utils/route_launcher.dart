/// 全局路由启动器
class RouteLauncher {
  RouteLauncher._();

  static final _launchMap = {};

  static void register(Map<String, Function> launchMap) {
    _launchMap.addAll(launchMap);
  }

  static Function? of(String path) {
    return _launchMap[path];
  }
}
