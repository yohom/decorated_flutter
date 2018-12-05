import 'dart:async';
import 'dart:ui';

import 'package:decorated_flutter/framework.dart';
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
    L.p('关闭所有验证码定时器');
  }

  VoidCallback callback;

  bool started = false;
  bool done = false;
  bool disposed = false;

  int remain = kDuration;

  StreamSubscription<int> _subscription;
  Observable<int> _timer;

  void start() {
    started = true;
    if (done || _subscription == null) {
      done = false;
      _timer = Observable.periodic(Duration(seconds: 1), (data) {
        return kDuration - 1 - data;
      }).take(kDuration).doOnDone(() {
        done = true;
        started = false;
        callback();
        _subscription?.cancel();
      });
      _subscription = _timer.listen((tick) {
        remain = tick;
        callback();
      });
    }
  }

  void addListener(VoidCallback callback) {
    this.callback = callback;
  }

  void dispose() async {
    await _subscription?.cancel();
  }
}
