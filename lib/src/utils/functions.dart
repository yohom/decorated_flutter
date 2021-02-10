import 'dart:math';

import 'package:decorated_flutter/decorated_flutter.dart';
import 'package:flutter/services.dart';

final notEqual = (prev, next) => prev != next;
final notNull = (data) => data != null;
final notEmpty = (data) => isNotEmpty(data);
final isTrue = (bool data) => data == true;
final isFalse = (bool data) => data == false;
final returnNull = () => null;

void doNothing() {}

void doNothing1(_) {}

void doNothing2(_, __) {}

/// 透传
T passthrough<T>(T data) => data;

/// 关闭键盘
///
/// 这个函数和通过FocusScope.unfocus()的区别是在关闭键盘的同时可以保持焦点
Future<void> hideKeyboard() {
  return SystemChannels.textInput.invokeMethod('TextInput.hide');
}

/// 打开键盘
Future<void> showKeyboard() {
  return SystemChannels.textInput.invokeMethod('TextInput.show');
}

/// 生成指定长度的随机字符串
String generateRandomString(int len) {
  final r = Random();
  return String.fromCharCodes(List.generate(len, (_) => r.nextInt(33) + 89));
}
