import 'package:decorated_flutter/decorated_flutter.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';

class DecoratedPage<B extends BLoC, R> extends MaterialPage {
  const DecoratedPage({
    B? bloc,
    required Widget screen,
    this.autoCloseKeyboard = const CloseKeyboardConfig(),
    this.init,
    this.onLateinit,
    this.animate = true,
    this.withForm = false,
    this.localNavigatorConfig,
    this.tabControllerConfig,
    this.onDisposed,
    this.onWillPop,
    this.systemUiOverlayStyle,
    this.animationBuilder,
    this.autoDispose = true,
    this.decorationBuilder,
    this.backgroundBuilder,
    this.foregroundBuilder,
    this.primaryScrollControllerConfig,
    required String routeName,
    super.fullscreenDialog,
    super.maintainState,
  })  : _bloc = bloc,
        super(child: screen);

  final B? _bloc;

  /// 是否自动关闭输入法
  final CloseKeyboardConfig? autoCloseKeyboard;

  /// 初始化方法
  ///
  /// [init]与[onLateinit]设计目的是[init]用来设置静态数据, [onLateinit]设置网络请求数据.
  /// 因为在使用lateinit的过程中, 发现如果widget中需要在初始化的时候用到静态数据, 由于lateinit的缘故
  /// 会导致拿不到静态数据, 所以这里区分一下静态的初始化和动态的初始化(网络请求数据)
  final InitCallback<B>? init;

  /// 入场动画结束后的初始化方法
  final LateInitCallback<B>? onLateinit;

  /// 是否执行动画
  final bool animate;

  /// 是否带有表单
  final bool withForm;

  /// 是否局部navigator
  final LocalNavigatorConfig? localNavigatorConfig;

  /// 是否使用[PrimaryScrollController]
  final PrimaryScrollControllerConfig? primaryScrollControllerConfig;

  /// 如果需要TabBar, 则配置这个对象
  final TabControllerConfig? tabControllerConfig;

  final VoidCallback? onDisposed;

  final WillPopCallback? onWillPop;

  /// 系统ui
  final SystemUiOverlayStyle? systemUiOverlayStyle;

  /// 自定义的动画
  final Widget Function(Animation<double>, Widget)? animationBuilder;

  /// 是否自动dispose BLoC
  final bool autoDispose;

  /// 自定义的样式
  final BoxDecoration Function(BuildContext)? decorationBuilder;

  /// 背景
  final WidgetBuilder? backgroundBuilder;

  /// 前景
  final WidgetBuilder? foregroundBuilder;

  @override
  Route createRoute(BuildContext context) {
    return DecoratedRoute<B, R>(
      bloc: _bloc,
      screen: child,
      animate: animate,
      autoCloseKeyboard: autoCloseKeyboard,
      autoDispose: autoDispose,
      backgroundBuilder: backgroundBuilder,
      decorationBuilder: decorationBuilder,
      foregroundBuilder: foregroundBuilder,
      init: init,
      localNavigatorConfig: localNavigatorConfig,
      onDisposed: onDisposed,
      onLateinit: onLateinit,
      onWillPop: onWillPop,
      primaryScrollControllerConfig: primaryScrollControllerConfig,
      routeName: name ?? runtimeType.toString(),
    );
  }
}
