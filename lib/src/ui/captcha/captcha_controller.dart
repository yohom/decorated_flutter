import 'dart:async';
import 'dart:ui';

import 'package:rxdart/rxdart.dart';

const int kDuration = 60;

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

  int remain = kDuration;

  Timer _timer;

  void start() {
    started = true;
    if (done || _timer == null) {
      done = false;
      _timer = Timer.periodic(Duration(seconds: kDuration), (timer) {
        remain = kDuration - 1 - timer.tick;
        callback();

        if (remain == 0) {
          done = true;
          started = false;
          callback();
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
