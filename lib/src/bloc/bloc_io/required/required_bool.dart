part of '../base.dart';

/// 只接收bool类型数据的IO
class BoolIO extends IO<bool> with BoolMixin {
  BoolIO({
    required super.seedValue,
    required super.semantics,
    super.sync,
    super.isBehavior,
    super.acceptEmpty,
    super.isDistinct,
    super.printLog,
    super.onUpdate,
    super.onReset,
    super.persistConfig,
  });
}

/// 只接收bool类型数据的Output
class BoolOutput<ARG> extends Output<bool, ARG> with BoolMixin {
  BoolOutput({
    required super.seedValue,
    required super.semantics,
    super.sync,
    super.isBehavior,
    super.printLog,
    required super.onUpdate,
    super.onReset,
    super.persistConfig,
  });
}

mixin BoolMixin on BaseIO<bool> {
  /// 切换true/false 并发射
  bool? toggle() {
    if (_subject.isClosed) {
      L.w('[DECORATED_FLUTTER] IO在close状态下请求发送数据');
      return null;
    }

    final toggled = !latest;
    _subject.add(toggled);
    return toggled;
  }
}
