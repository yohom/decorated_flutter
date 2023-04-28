import 'package:decorated_flutter/src/extension/route_settings.x.dart';
import 'package:flutter/widgets.dart';

extension NavigatorX on NavigatorState {
  Future<void> clearToRoot() async {
    await pushNamedAndRemoveUntil('/', (route) => false);
  }

  void popUntilNamed(String routeName) {
    popUntil(ModalRoute.withName(routeName));
  }

  void popUntilAny(List<String> routes) {
    popUntil((route) => routes.contains(route.settings.path));
  }
}
