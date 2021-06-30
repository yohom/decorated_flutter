import 'package:flutter/cupertino.dart';

import 'string.x.dart';

extension RouteSettingsX on RouteSettings {
  /// 获取所有可用的参数
  ///
  /// 包括[arguments]和[name]中可以解析出来的参数
  Map<String, dynamic> get availableArguments {
    final _arguments = arguments as Map<String, dynamic>? ?? {};
    final _queryParameter = name?.uri?.queryParameters ?? {};
    return {..._arguments, ..._queryParameter};
  }

  /// 路由的路径
  ///
  /// 会已uri的格式解析, 并拿出当中路径的部分
  String? get path {
    return name?.uri?.path;
  }
}
