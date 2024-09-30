import 'dart:convert';

import 'package:flutter/widgets.dart';
import 'package:hive_flutter/hive_flutter.dart';
import 'package:shared_preferences/shared_preferences.dart';

import 'logger/logger.dart';

/// 当不关心对象是什么, 但是又必须存在一个对象的时候, 使用这个
final dynamic anyObject = Object();

const anyString = '';

final gNavigatorKey = GlobalKey<NavigatorState>();

final kEmailRegex = RegExp(
    r"""([-!#-'*+/-9=?A-Z^-~]+(\.[-!#-'*+/-9=?A-Z^-~]+)*|"([]!#-[^-~ \t]|(\\[\t -~]))+")@[0-9A-Za-z]([0-9A-Za-z-]{0,61}[0-9A-Za-z])?(\.[0-9A-Za-z]([0-9A-Za-z-]{0,61}[0-9A-Za-z])?)+""");

final kMoneyRegex =
    RegExp(r'(^[1-9](\d+)?(\.\d{1,2})?$)|(^(0)$)|(^\d\.\d(\d)?$)');

final kIpV4Regex = RegExp(r'^(?:[0-9]{1,3}\.){3}[0-9]{1,3}$');

// decorated专属存储
late SharedPreferences _box;
late Box _legacyBox;
Future<void> initDecoratedBox() async {
  L.d('开始初始化decorated专属存储持久层');
  _box = await SharedPreferences.getInstance();

  try {
    // 小程序端会报错, 这里try catch一下
    await Hive.initFlutter();
    _legacyBox = await Hive.openBox('decorated_flutter_box');

    // 迁移遗留数据
    for (final item in _legacyBox.keys) {
      await _box.setString(item, jsonEncode(_legacyBox.get(item)));
    }
    // 迁移完成后清空遗留数据
    await _legacyBox.clear();
    L.i('遗留数据迁移完成, 已迁移key: ${_box.getKeys()}');
  } catch (e) {
    L.e('初始化遗留存储时出现异常, 跳过其流程: $e');
  }

  L.d('结束初始化decorated专属存储持久层');
}

SharedPreferences get gDecoratedStorage => _box;
