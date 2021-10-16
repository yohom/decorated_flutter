import 'package:flutter/widgets.dart';

/// 当不关心对象是什么, 但是又必须存在一个对象的时候, 使用这个
final anyObject = Object();

final gNavigatorKey = GlobalKey<NavigatorState>();

final kMobileRegex =
    RegExp(r'^1(3\d|4[5-9]|5[0-35-9]|6[2567]|7[0-8]|8\d|9[0-35-9])\d{8}$');
