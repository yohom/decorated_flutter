import 'package:flutter/widgets.dart';

extension NavigatorX on NavigatorState {
  void clearToRoot() {
    pushNamedAndRemoveUntil('/', (route) => false);
  }
}
