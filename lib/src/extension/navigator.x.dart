import 'package:flutter/widgets.dart';

extension NavigatorX on NavigatorState {
  Future<void> clearToRoot() async {
    await pushNamedAndRemoveUntil('/', (route) => false);
  }

  void popUntilNamed(String routeName) {
    popUntil(ModalRoute.withName(routeName));
  }
}
