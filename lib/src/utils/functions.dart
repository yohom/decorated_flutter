import 'dart:async';
import 'dart:convert';
import 'dart:io';
import 'dart:math';

import 'package:crypto/crypto.dart';
import 'package:decorated_flutter/src/extension/extension.export.dart';
import 'package:decorated_flutter/src/mixin/mixin.export.dart';
import 'package:flutter/services.dart';
import 'package:flutter/widgets.dart';
import 'package:uuid/uuid.dart';

import 'logger/logger.dart';
import 'objects.dart';
import 'retry.dart';

bool notEqual(prev, next) => prev != next;

bool notNull(data) => data != null;

bool isNull(data) => data == null;

bool isTrue(bool? data) => data == true;

bool isFalse(bool? data) => data == false;

T? returnNull<T>() => null;

void doNothing() {}

void doNothing1(_) {}

void doNothing2(_, __) {}

/// 透传
T passthrough<T>(T data) => data;

/// 执行一段回调
T doFunc<T>(T Function() func) {
  return func();
}

/// 获取md5
String md5Of(List<int> input) {
  return md5.convert(input).toString();
}

/// 获取md5
String md5OfString(String input) {
  return md5Of(utf8.encode(input));
}

/// 获取md5
///
/// 当文件大小超过[streamThreshold]时, 启用流式处理, 避免大文件干爆内存
Future<String> md5OfFile(
  File file, {
  int streamThreshold = 10 * 1024 * 1024,
}) async {
  if (await file.length() > streamThreshold) {
    final stream = file.openRead();
    return md5.bind(stream).first.then(toString);
  } else {
    return md5Of(await file.readAsBytes());
  }
}

/// 获取md5
Future<String> md5OfStream(Stream<Uint8List> stream) {
  return md5.bind(stream).first.then(toString);
}

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

final r = Random();

/// 生成指定长度的随机字符串
String randomString(int len) {
  return String.fromCharCodes(List.generate(len, (_) => r.nextInt(33) + 89));
}

@Deprecated('randomString代替')
String generateRandomString(int len) => randomString(len);

/// 生成指定长度的随机数字
String randomNumber(int len) {
  return List.generate(len, (_) => r.nextInt(10)).join();
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
Future<void> runDecoratedApp({
  required FutureOr<void> Function() appRunner,
  FutureOr<void> Function()? beforeApp,
  FutureOr<void> Function()? afterApp,
  FutureOr<void> Function(Object, StackTrace)? onError,
  Color? statusBarColor,
  bool zoned = true,
  bool isTest = false,
  bool withFileLogger = true,
}) async {
  WidgetsFlutterBinding.ensureInitialized();

  // 初始化日志系统
  await L.init(withFileLogger: withFileLogger);

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

  // 非测试状态下, 运行app; 测试状态下, 需要由集成测试的tester来bump widget
  if (!isTest) {
    if (zoned) {
      runZonedGuarded<void>(
        appRunner,
        (e, s) {
          if (onError != null) {
            onError.call(e, s);
          } else {
            L.e('error: $e, stacktrace: $s');
          }
        },
      );
    } else {
      appRunner();
    }
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

/// 下一帧回调
void nextFrame(VoidCallback cb) {
  WidgetsBinding.instance.addPostFrameCallback((_) => cb());
}

/// 获取文件大小
String filesize(dynamic size, [int round = 2]) {
  /**
   * [size] can be passed as number or as string
   *
   * the optional parameter [round] specifies the number
   * of digits after comma/point (default is 2)
   */
  var divider = 1024;
  int _size;
  try {
    _size = int.parse(size.toString());
  } catch (e) {
    throw ArgumentError('Can not parse the size parameter: $e');
  }

  if (_size < divider) {
    return '$_size B';
  }

  if (_size < divider * divider && _size % divider == 0) {
    return '${(_size / divider).toStringAsFixed(0)} KB';
  }

  if (_size < divider * divider) {
    return '${(_size / divider).toStringAsFixed(round)} KB';
  }

  if (_size < divider * divider * divider && _size % divider == 0) {
    return '${(_size / (divider * divider)).toStringAsFixed(0)} MB';
  }

  if (_size < divider * divider * divider) {
    return '${(_size / divider / divider).toStringAsFixed(round)} MB';
  }

  if (_size < divider * divider * divider * divider && _size % divider == 0) {
    return '${(_size / (divider * divider * divider)).toStringAsFixed(0)} GB';
  }

  if (_size < divider * divider * divider * divider) {
    return '${(_size / divider / divider / divider).toStringAsFixed(round)} GB';
  }

  if (_size < divider * divider * divider * divider * divider &&
      _size % divider == 0) {
    num r = _size / divider / divider / divider / divider;
    return '${r.toStringAsFixed(0)} TB';
  }

  if (_size < divider * divider * divider * divider * divider) {
    num r = _size / divider / divider / divider / divider;
    return '${r.toStringAsFixed(round)} TB';
  }

  if (_size < divider * divider * divider * divider * divider * divider &&
      _size % divider == 0) {
    num r = _size / divider / divider / divider / divider / divider;
    return '${r.toStringAsFixed(0)} PB';
  } else {
    num r = _size / divider / divider / divider / divider / divider;
    return '${r.toStringAsFixed(round)} PB';
  }
}

/// 写入一个临时文件
Future<File?> getTmpFile(
  Uint8List? bytes, {
  required Directory dir,
  String ext = '',
}) async {
  if (bytes == null) return null;

  final file = File('${dir.path}/${const Uuid().v4()}${ext.prefixWith('.')}');
  await file.writeAsBytes(bytes);
  return file;
}

void resetSelectable(Selectable selectable) {
  selectable.reset();
}

T getFirst<T>(List<T> list) {
  return list.first;
}

T? getFirstOrNull<T>(List<T> list) {
  return list.firstOrNull;
}

/// 等待某个操作符合要求
///
/// 使用[retry]的变体来简化实现
Future<void> waitFor(
  FutureOr<bool> Function() fn, {
  Duration delayFactor = const Duration(milliseconds: 200),
  double randomizationFactor = 0.25,
  Duration maxDelay = const Duration(seconds: 30),
  int maxAttempts = 8,
}) {
  return RetryOptions(
    delayFactor: delayFactor,
    randomizationFactor: randomizationFactor,
    maxDelay: maxDelay,
    maxAttempts: maxAttempts,
  ).retry(doNothing, retryIf: (_) async => !(await fn()));
}
