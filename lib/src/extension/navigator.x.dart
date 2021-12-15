import 'package:flutter/widgets.dart';

extension NavigatorX on NavigatorState {
  void clearToRoot() {
    pushNamedAndRemoveUntil('/', (route) => false);
  }

  void popUntilNamed(String routeName) {
    popUntil(ModalRoute.withName(routeName));
  }
}
