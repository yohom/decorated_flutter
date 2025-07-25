import 'dart:async';
import 'dart:convert';
import 'dart:io';
import 'dart:math';

import 'package:crypto/crypto.dart';
import 'package:decorated_flutter/decorated_flutter.dart';
import 'package:flutter/services.dart';
import 'package:flutter/widgets.dart';
import 'package:uuid/uuid.dart';

bool notEqual(prev, next) => prev != next;

bool notNull(data) => data != null;

bool isNull(data) => data == null;

bool isTrue(bool? data) => data == true;

bool isFalse(bool? data) => data == false;

T? returnNull<T>() => null;

bool returnFalse() => false;

bool returnTrue() => true;

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
@Deprecated('使用retry代替')
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
      L.d('[DECORATED_FLUTTER] 执行第$tryCount次轮询');
      try {
        await task();
        L.d('[DECORATED_FLUTTER] 第$tryCount次轮询执行成功');
        // 成功就马上break
        break;
      } catch (e) {
        String message = '第$tryCount次轮询失败, 错误信息: $e';
        if (whenErrorTry != null) {
          L.d('[DECORATED_FLUTTER] $message 开始执行错误重试');
          await whenErrorTry();
        } else {
          L.d('[DECORATED_FLUTTER] $message 未配置错误重试, 抛出异常');
          rethrow;
        }
      }
      await Future.delayed(interval);
    } else {
      L.d('[DECORATED_FLUTTER] 超出轮询尝试次数');
      throw '超出轮询尝试次数';
    }
  }
  L.d('[DECORATED_FLUTTER] 轮询执行结束');
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
  L.d('[DECORATED_FLUTTER] ${tag != null ? '[$tag] ' : ''}当前时间戳: $now');
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
  SystemUiMode? systemUiMode,
  Color? statusBarColor,
  Color? systemNavigationBarColor,
  Color? systemNavigationBarDividerColor,
  Brightness? statusBarBrightness,
  Brightness? statusBarIconBrightness,
  Brightness? systemNavigationBarIconBrightness,
  bool? systemNavigationBarContrastEnforced,
  bool? systemStatusBarContrastEnforced,
  bool zoned = true,
  bool isTest = false,
  @Deprecated('已无作用') bool withFileLogger = true,
}) async {
  // 运行app
  Future<void> __runner() async {
    WidgetsFlutterBinding.ensureInitialized();

    // 初始化日志系统
    await L.init();

    if (systemUiMode != null) {
      await SystemChrome.setEnabledSystemUIMode(systemUiMode);
    }

    if (statusBarColor != null ||
        statusBarBrightness != null ||
        statusBarIconBrightness != null ||
        systemNavigationBarColor != null ||
        systemNavigationBarIconBrightness != null ||
        systemNavigationBarDividerColor != null ||
        systemNavigationBarContrastEnforced != null ||
        systemStatusBarContrastEnforced != null) {
      SystemChrome.setSystemUIOverlayStyle(
        SystemUiOverlayStyle.dark.copyWith(
          statusBarColor: statusBarColor,
          statusBarBrightness: statusBarBrightness,
          statusBarIconBrightness: statusBarIconBrightness,
          systemNavigationBarColor: systemNavigationBarColor,
          systemNavigationBarIconBrightness: systemNavigationBarIconBrightness,
          systemNavigationBarDividerColor: systemNavigationBarDividerColor,
          systemNavigationBarContrastEnforced:
              systemNavigationBarContrastEnforced,
          systemStatusBarContrastEnforced: systemStatusBarContrastEnforced,
        ),
      );
    }

    if (beforeApp != null) {
      try {
        await initDecoratedBox();
        await beforeApp();
      } catch (e, s) {
        L.w('[DECORATED_FLUTTER] 运行app前置工作出现异常, 请检查是否有bug!. $e\n $s');
      }
    }

    await appRunner();

    if (afterApp != null) {
      try {
        await afterApp();
      } catch (e, s) {
        L.w('[DECORATED_FLUTTER] 运行app后置工作出现异常, 请检查是否有bug!. $e\n $s');
      }
    }
  }

  // 错误处理
  void __handleError(Object e, StackTrace s) {
    if (onError != null) {
      onError.call(e, s);
    } else {
      L.e('[DECORATED_FLUTTER] error: $e, stacktrace: $s');
    }
  }

  // 非测试状态下, 运行app; 测试状态下, 需要由集成测试的tester来bump widget
  if (!isTest) {
    if (zoned) {
      runZonedGuarded<void>(__runner, __handleError);
    } else {
      __runner();
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
  int maxAttempts = 8,
  String message = '等待',
}) async {
  for (int i = 0; i < maxAttempts; i++) {
    L.d('[DECORATED_FLUTTER] 第 $i 次获取 $message 状态');
    if (await fn()) {
      break;
    } else {
      await Future.delayed(delayFactor);
    }
  }
}

/// 对一个函数[decorated]做防抖处理
void Function() debounce(Duration duration, void Function() decorated) {
  Timer? timer;
  return () {
    timer?.cancel();
    timer = Timer(duration, () => decorated());
  };
}

AnimationController createAnimation(
  TickerProvider vsync, {
  required ValueChanged<double> callback,
  required Duration duration,
  Curve curve = Curves.ease,
  double lowerBound = 0,
  double upperBound = 1,
}) {
  final controller = AnimationController(vsync: vsync, duration: duration);
  final curvedAnimation = CurvedAnimation(parent: controller, curve: curve);

  curvedAnimation.addListener(
    () => callback(
      lowerBound + (curvedAnimation.value) * (upperBound - lowerBound),
    ),
  );

  return controller;
}

Stream<(T1, T2)> combine2<T1, T2>(Stream<T1> streamA, Stream<T2> streamB) {
  return Rx.combineLatest2(streamA, streamB, (a, b) => (a, b));
}

Stream<(T1, T2, T3)> combine3<T1, T2, T3>(
  Stream<T1> streamA,
  Stream<T2> streamB,
  Stream<T3> streamC,
) {
  return Rx.combineLatest3(
    streamA,
    streamB,
    streamC,
    (a, b, c) => (a, b, c),
  );
}

Stream<(T1, T2, T3, T4)> combine4<T1, T2, T3, T4>(
  Stream<T1> streamA,
  Stream<T2> streamB,
  Stream<T3> streamC,
  Stream<T4> streamD,
) {
  return Rx.combineLatest4(
    streamA,
    streamB,
    streamC,
    streamD,
    (a, b, c, d) => (a, b, c, d),
  );
}
