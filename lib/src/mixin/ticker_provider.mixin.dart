import 'package:decorated_flutter/src/bloc/bloc.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/scheduler.dart';
import 'package:flutter/widgets.dart';

/// 为BLoC提供一个简单的[TickerProvider]
///
/// 跟[State]提供的[TickerProvider]有点区别, [SingleTickerProviderBLoCMixin]去掉了对
/// 动画是否在屏幕外的检测, 因为[BuildContext]无法获取
mixin SingleTickerProviderBLoCMixin on BLoC implements TickerProvider {
  @override
  Ticker createTicker(TickerCallback onTick) {
    return Ticker(
      onTick,
      debugLabel: kDebugMode ? 'created by ${describeIdentity(this)}' : null,
    );
  }
}
