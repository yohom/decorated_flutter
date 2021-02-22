import 'package:flutter/widgets.dart';

extension NavigatorX on NavigatorState {
  Future<void> clearToRoot() {
    return pushNamedAndRemoveUntil('/', (route) => false);
  }
}
