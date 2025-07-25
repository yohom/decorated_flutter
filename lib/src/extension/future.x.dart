import 'dart:async';

import 'package:decorated_flutter/decorated_flutter.dart';
import 'package:flutter/material.dart';

typedef LoadingBuilder = Widget Function(
  BuildContext context,
  String loadingText,
);

/// 全局的是否在loading中的stream
final _loadingStreamController = StreamController<Object?>.broadcast();

extension FutureX<T> on Future<T> {
  static LoadingBuilder? loadingWidgetBuilder;
  static Color? backgroundColor;
  static bool loadingCancelable = false;
  static String defaultLoadingText = '加载中...';
  // 默认无超时
  static Duration defaultTimeLimit = const Duration(days: 1);

  /// loading的entry
  ///
  /// 开放访问可以让外部系统自行决定loading的层级
  static OverlayEntry? _loadingEntry;
  static OverlayEntry? get loadingEntry => _loadingEntry;

  static Stream<bool> get inLoading {
    return _loadingStreamController.stream.map((tag) => tag != null);
  }

  static Stream<Object?> get inLoadingTag {
    return _loadingStreamController.stream;
  }

  /// 造型为[R]类型
  Future<R> cast<R>() {
    return then((data) => data as R);
  }

  /// 显示loading
  ///
  /// [tag]可以用来区分是谁在loading
  Future<T> loading({
    bool? cancelable,
    Duration? timeLimit,
    String? loadingText,
    Color? backgroundColor,
    bool modal = true,
    Object tag = '__default__',
  }) {
    final context = gNavigatorKey.currentContext;
    if (context == null) {
      throw '请在MaterialApp/CupertinoApp中设置navigatorKey为gNavigatorKey';
    }

    _loadingStreamController.add(tag);

    final overlay =
        Overlay.maybeOf(context, rootOverlay: true) ?? gNavigator.overlay;
    if (overlay == null) {
      L.w('[DECORATED_FLUTTER] 无法获取到有效的Overlay! 请检查Widget树结构!');
    }
    final theme = Theme.of(context);
    final controller = AnimationController(
      duration: const Duration(milliseconds: 128),
      vsync: Navigator.of(context),
    );
    final opacityAnimation =
        Tween<double>(begin: 0.0, end: 1.0).animate(controller);

    void __pop() {
      controller.reverse().whenComplete(() {
        _loadingEntry?.remove();
        _loadingEntry = null;
      });
    }

    if (modal) {
      if (_loadingEntry != null) {
        L.i('[DECORATED_FLUTTER] 当前已在Loading中, 跳过此次Loading请求');
        return this;
      }

      final text = loadingText ?? defaultLoadingText;
      final isCancelable = cancelable ?? loadingCancelable;
      final loadingWidget =
          loadingWidgetBuilder?.call(context, text) ?? ModalLoading(text);
      _loadingEntry ??= OverlayEntry(
        builder: (context) {
          return Theme(
            data: theme,
            child: RepaintBoundary(
              child: AnimatedBuilder(
                animation: opacityAnimation,
                child: PopScope(
                  canPop: isCancelable,
                  child: GestureDetector(
                    onTap: isCancelable ? __pop : null,
                    child: loadingWidget,
                  ),
                ),
                builder: (context, child) {
                  return Opacity(
                    opacity: opacityAnimation.value,
                    child: child,
                  );
                },
              ),
            ),
          );
        },
      );

      try {
        overlay?.insert(_loadingEntry!);
        controller.forward();
      } catch (e, s) {
        L.w('[DECORATED_FLUTTER] Loading时出现异常, 跳过此次Loading请求, 错误信息: $e, 堆栈信息: $s');
      }
    }

    return timeout(timeLimit ?? defaultTimeLimit).whenComplete(() {
      __pop();
      _loadingStreamController.add(null);
    });
  }

  /// apply一个回调, 然后返回当前对象
  Future<T> apply<R>(
    FutureOr<R> Function(T value) onValue, {
    Function? onError,
  }) async {
    await then(onValue, onError: onError);
    return this;
  }

  /// 根据[condition]判断是否要执行[action]
  Future<T> thenIf(bool condition, VoidCallback action) {
    if (condition) {
      action();
    }
    return this;
  }

  /// 根据[condition]判断是否要执行[action]
  Future<T> thenIfNot(bool condition, VoidCallback action) {
    if (!condition) {
      action();
    }
    return this;
  }

  /// 延迟一段时间
  Future<T> delay(Duration duration) async {
    return then((value) async {
      await Future.delayed(duration);
      return value;
    });
  }

  /// 当前Future正常结束后执行pop
  Future<void> thenPop<R>({
    String? until,
    R? withValue,
    BuildContext? context,
  }) {
    return then((_) {
      final navigator = context?.navigator ?? gNavigatorKey.currentState;
      until == null
          ? navigator?.pop<R>(withValue)
          : navigator?.popUntil(ModalRoute.withName(until));
    });
  }

  /// 当前Future正常结束后执行pop
  Future<void> thenPopToRoot() {
    return then((_) => gNavigatorKey.currentState?.clearToRoot());
  }

  /// 当前Future正常结束后推入route
  Future<void> thenPushNamed(String routeName, {Object? arguments}) {
    return then(
      (_) => gNavigatorKey.currentState?.pushNamed(
        routeName,
        arguments: arguments,
      ),
    );
  }

  /// 当前Future正常结束后推入route
  Future<void> thenReplaceNamed(String routeName, {Object? arguments}) {
    return then(
      (_) => gNavigatorKey.currentState?.pushReplacementNamed(
        routeName,
        arguments: arguments,
      ),
    );
  }
}

extension StringFutureX on Future<String> {
  Future<String> operator +(String text) async {
    return (await this) + text;
  }
}

extension IterableFutureX<T> on Future<Iterable<T>> {
  Future<T?> get thenFirstOrNull {
    return then((value) => value.firstOrNull);
  }

  Future<T> get thenFirst {
    return then((value) => value.first);
  }

  Future<List<T>> thenTake(int count) {
    return then((value) => value.take((count)).toList());
  }

  Future<List<T>> thenSkip(int count) {
    return then((value) => value.skip((count)).toList());
  }
}
