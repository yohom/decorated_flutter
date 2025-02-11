import 'package:decorated_flutter/src/extension/route_settings.x.dart';
import 'package:flutter/widgets.dart';

extension ModalRouteDecoratedX on ModalRoute {
  dynamic operator [](String key) {
    return settings.availableArguments[key];
  }
}
