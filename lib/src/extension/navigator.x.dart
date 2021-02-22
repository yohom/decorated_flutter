import 'package:flutter/widgets.dart';

extension NavigatorX on Navigator {
  Future<void> clearToRoot(BuildContext context) {
    return Navigator.of(context).pushNamedAndRemoveUntil('/', (route) => false);
  }
}
