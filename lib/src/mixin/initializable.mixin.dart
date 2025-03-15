import 'dart:async';

import 'package:flutter/widgets.dart';

/// 可初始化组件的通用逻辑
///
/// 设计目的用于三方SDK按需初始化, 而不是在app启动时一起初始化, 容易引起应用商店被拒
mixin InitializableMixin {
  // ignore: unused_field
  _State _initializeState = _State.uninitialized;

  @mustCallSuper
  FutureOr<void> initialize() {
    _initializeState = _State.initializing;
  }
}

enum _State {
  uninitialized,
  initializing,
  initialized;

  bool get isInitialized => this == initialized;
  bool get isUninitialized => this == uninitialized;
  bool get isInitializing => this == initializing;
}
