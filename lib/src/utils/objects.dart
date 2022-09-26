import 'package:flutter/widgets.dart';
import 'package:hive_flutter/hive_flutter.dart';

import 'log.dart';

/// 当不关心对象是什么, 但是又必须存在一个对象的时候, 使用这个
final anyObject = Object();

const anyString = '';

final gNavigatorKey = GlobalKey<NavigatorState>();

final kMobileRegex =
    RegExp(r'^1(3\d|4[5-9]|5[0-35-9]|6[2567]|7[0-8]|8\d|9[0-35-9])\d{8}$');

final kEmailRegex = RegExp(
    r"""([-!#-'*+/-9=?A-Z^-~]+(\.[-!#-'*+/-9=?A-Z^-~]+)*|"([]!#-[^-~ \t]|(\\[\t -~]))+")@[0-9A-Za-z]([0-9A-Za-z-]{0,61}[0-9A-Za-z])?(\.[0-9A-Za-z]([0-9A-Za-z-]{0,61}[0-9A-Za-z])?)+""");

final kMoneyRegex =
    RegExp(r'(^[1-9](\d+)?(\.\d{1,2})?$)|(^(0)$)|(^\d\.\d(\d)?$)');

final kIpV4Regex = RegExp(r'^(?:[0-9]{1,3}\.){3}[0-9]{1,3}$');

// decorated专属存储
late Box _box;
Future<void> initDecoratedBox() async {
  L.i('开始初始化decorated专属存储持久层');
  await Hive.initFlutter();
  _box = await Hive.openBox('decorated_flutter_box');
  L.i('结束初始化decorated专属存储持久层');
}

Box get gDecoratedStorage => _box;
