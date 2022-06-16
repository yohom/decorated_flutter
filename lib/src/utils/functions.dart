import 'dart:async';
import 'dart:convert';
import 'dart:math';

import 'package:decorated_flutter/decorated_flutter.dart';
import 'package:flutter/services.dart';
import 'package:flutter/widgets.dart';

bool notEqual(prev, next) => prev != next;

bool notNull(data) => data != null;

bool isNull(data) => data == null;

bool isTrue(bool data) => data == true;

bool isFalse(bool data) => data == false;

T? returnNull<T>() => null;

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
  required Future<void> Function() task,
  required Duration interval,
  required int maxTryCount,
  Future<void> Function()? whenErrorTry,
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
        String message = '第$tryCount次轮询失败, 错误信息: $e';
        if (whenErrorTry != null) {
          L.d('$message 开始执行错误重试');
          await whenErrorTry();
        } else {
          L.d('$message 未配置错误重试, 抛出异常');
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

/// 求最大值
T maxValue<T extends Comparable>(T value1, T value2) {
  return value1.compareTo(value2) >= 0 ? value1 : value2;
}

/// 求最小值
T minValue<T extends Comparable>(T value1, T value2) {
  return value1.compareTo(value2) < 0 ? value1 : value2;
}

/// 打印当前时间
DateTime logTime([String? tag]) {
  final now = DateTime.now();
  L.d('${tag != null ? '[$tag] ' : ''}当前时间戳: $now');
  return now;
}

/// 通用的toString
String toString(Object object) {
  return object.toString();
}

/// 运行app
void runDecoratedApp(
  Widget app, {
  Future<void> Function()? beforeApp,
  Future<void> Function()? afterApp,
  Future<void> Function(Object, StackTrace)? onError,
  Color? statusBarColor,
  bool zoned = true,
  bool enableFileOutput = true,
}) async {
  WidgetsFlutterBinding.ensureInitialized();

  // 初始化日志系统
  await L.init(enableFileOutput: enableFileOutput);

  if (statusBarColor != null) {
    SystemChrome.setSystemUIOverlayStyle(
      SystemUiOverlayStyle.dark.copyWith(statusBarColor: statusBarColor),
    );
  }

  if (beforeApp != null) {
    try {
      await initDecoratedBox();
      await beforeApp();
    } catch (e, s) {
      L.w('运行app前置工作出现异常, 请检查是否有bug!. $e\n $s');
    }
  }

  if (zoned) {
    runZonedGuarded<void>(
      () => runApp(app),
      (e, s) {
        if (onError != null) {
          onError.call(e, s);
        } else {
          L.e('error: $e, stacktrace: $s');
        }
      },
    );
  } else {
    runApp(app);
  }

  if (afterApp != null) {
    try {
      await afterApp();
    } catch (e, s) {
      L.w('运行app后置工作出现异常, 请检查是否有bug!. $e\n $s');
    }
  }
}

/// 是否可以转换为json的
bool isJsonable(Object? object) {
  try {
    jsonEncode(object);
    return true;
  } catch (_) {
    return false;
  }
}

/// 强制解析出一个日期
///
/// 如果解析出错, 就根据[fallback]逻辑构造一个代替时间
DateTime requireDate(
  String? dateString, {
  DateTime Function()? fallback,
}) {
  try {
    return DateTime.parse(dateString!);
  } catch (e) {
    L.w('解析日期出错, 使用当前时间代替, 错误信息: $e');
    return fallback?.call() ?? DateTime.now();
  }
}

/// 下一帧回调
void nextFrame(VoidCallback cb) {
  WidgetsBinding.instance.addPostFrameCallback((_) => cb());
}
