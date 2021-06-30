import 'package:flutter/cupertino.dart';

import 'string.x.dart';

extension RouteSettingsX on RouteSettings {
  Map<String, dynamic> get availableArguments {
    final _arguments = arguments as Map<String, dynamic>? ?? {};
    final _queryParameter = name?.uri?.queryParameters ?? {};
    return {..._arguments, ..._queryParameter};
  }
}
