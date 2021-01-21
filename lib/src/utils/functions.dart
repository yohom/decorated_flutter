import 'package:decorated_flutter/decorated_flutter.dart';
import 'package:flutter/services.dart';

final notEqual = (prev, next) => prev != next;
final notNull = (data) => data != null;
final notEmpty = (data) => isNotEmpty(data);
final isTrue = (bool data) => data == true;
final isFalse = (bool data) => data == false;
final returnNull = () => null;
final Function doNothing = () {};
final Function doNothing1 = (_) {};
final Function doNothing2 = (_, __) {};

/// 关闭键盘
///
/// 这个函数和通过FocusScope.unfocus()的区别是在关闭键盘的同时可以保持焦点
Future<void> hideKeyboard() {
  return SystemChannels.textInput.invokeMethod('TextInput.hide');
}
