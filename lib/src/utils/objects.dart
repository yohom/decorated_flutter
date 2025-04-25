import 'package:flutter/widgets.dart';
import 'package:shared_preferences/shared_preferences.dart';

import 'logger/logger.dart';

/// 当不关心对象是什么, 但是又必须存在一个对象的时候, 使用这个
final dynamic anyObject = Object();

const anyString = '';

final gNavigatorKey = GlobalKey<NavigatorState>();
NavigatorState get gNavigator => gNavigatorKey.currentState!;

final kEmailRegex = RegExp(
    r"""([-!#-'*+/-9=?A-Z^-~]+(\.[-!#-'*+/-9=?A-Z^-~]+)*|"([]!#-[^-~ \t]|(\\[\t -~]))+")@[0-9A-Za-z]([0-9A-Za-z-]{0,61}[0-9A-Za-z])?(\.[0-9A-Za-z]([0-9A-Za-z-]{0,61}[0-9A-Za-z])?)+""");

final kMoneyRegex =
    RegExp(r'(^[1-9](\d+)?(\.\d{1,2})?$)|(^(0)$)|(^\d\.\d(\d)?$)');

final kIpV4Regex = RegExp(r'^(?:[0-9]{1,3}\.){3}[0-9]{1,3}$');

// decorated专属存储
late SharedPreferences _box;
Future<void> initDecoratedBox() async {
  L.d('[DECORATED_FLUTTER] 开始初始化decorated专属存储持久层');
  _box = await SharedPreferences.getInstance();
  L.d('[DECORATED_FLUTTER] 结束初始化decorated专属存储持久层');
}

SharedPreferences get gDecoratedStorage => _box;
