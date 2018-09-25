import 'dart:async';
import 'dart:ui';

import 'package:rxdart/rxdart.dart';

const int kTotalDuration = 60;

/// 负责控制倒计时的类
class CaptchaController {
  CaptchaController._();

  factory CaptchaController(Type key) {
    if (!controllerMap.containsKey(key)) {
      controllerMap[key] = CaptchaController._();
    }
    return controllerMap[key];
  }

  static final controllerMap = Map<Type, CaptchaController>();

  static void disposeAll() {
    controllerMap.forEach((_, controller) => controller.dispose());
  }

  VoidCallback callback;

  bool started = false;
  bool done = false;
  bool disposed = false;

  int remain = kTotalDuration;

  Timer _timer;

  void start() {
    started = true;
    if (done || _timer == null) {
      done = false;
      _timer = Timer.periodic(Duration(seconds: 1), (timer) {
        remain = kTotalDuration - timer.tick;
        callback();

        if (remain == 0) {
          done = true;
          started = false;
          callback();
          _timer.cancel();
        }
      });
    }
  }

  void addListener(VoidCallback callback) {
    this.callback = callback;
  }

  void dispose() {
    _timer.cancel();
  }
}
