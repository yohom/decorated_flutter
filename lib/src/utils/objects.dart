import 'package:flutter/widgets.dart';
import 'package:hive_flutter/hive_flutter.dart';

/// 当不关心对象是什么, 但是又必须存在一个对象的时候, 使用这个
final anyObject = Object();

const anyString = '';

final gNavigatorKey = GlobalKey<NavigatorState>();

final kMobileRegex =
    RegExp(r'^1(3\d|4[5-9]|5[0-35-9]|6[2567]|7[0-8]|8\d|9[0-35-9])\d{8}$');

final kEmailRegex = RegExp(
    r"""([-!#-'*+/-9=?A-Z^-~]+(\.[-!#-'*+/-9=?A-Z^-~]+)*|"([]!#-[^-~ \t]|(\\[\t -~]))+")@[0-9A-Za-z]([0-9A-Za-z-]{0,61}[0-9A-Za-z])?(\.[0-9A-Za-z]([0-9A-Za-z-]{0,61}[0-9A-Za-z])?)+""");

final kMoneyRegex = RegExp(
    r'(^[1-9]([0-9]+)?(\.[0-9]{1,2})?$)|(^(0){1}$)|(^[0-9]\.[0-9]([0-9])?$)');

Future<Box> get gHiveBox => Hive.openBox('decorated_flutter_box');
