import 'dart:math';

import 'package:flutter/foundation.dart';
import 'package:flutter/services.dart';

import 'log.dart';

bool notEqual(prev, next) => prev != next;

bool notNull(data) => data != null;

bool isTrue(bool data) => data == true;

bool isFalse(bool data) => data == false;

T returnNull<T>() => null;

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

/// 通用轮询逻辑
Future<void> polling({
  @required Future<void> Function() task,
  @required Duration interval,
  @required int maxTryCount,
  Future<void> Function() whenErrorTry,
}) async {
  int tryCount = 0;
  while (true) {
    if (tryCount < maxTryCount) {
      tryCount++;
      L.d('执行第$tryCount次轮询');
      try {
        await task();
        L.d('第$tryCount次轮询执行成功');
        // 成功就马上break
        break;
      } catch (e) {
        if (whenErrorTry != null) {
          L.d('第$tryCount次轮询失败, 开始执行错误重试');
          await whenErrorTry();
        } else {
          L.d('第$tryCount次轮询失败, 未配置错误重试, 抛出异常');
          rethrow;
        }
      }
      await Future.delayed(interval);
    } else {
      L.d('超出轮询尝试次数');
      throw '超出轮询尝试次数';
    }
  }
  L.d('轮询执行结束');
}
