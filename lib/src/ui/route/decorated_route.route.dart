import 'package:decorated_flutter/decorated_flutter.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';

typedef _OnInit<T extends BLoC> = void Function(T bloc);
typedef _OnLateInit<T extends BLoC> = void Function(T bloc, BuildContext);

/// [B]是指定的BLoC, [T]是Route的返回类型
class DecoratedRoute<B extends BLoC, T> extends MaterialWithModalsPageRoute<T> {
  DecoratedRoute({
    Key? key,
    required this.screen,
    this.bloc,
    this.autoCloseKeyboard = true,
    this.init,
    this.onLateinit,
    this.animate = true,
    this.withForm = true,
    this.withLocalNavigator = false,
    this.tabControllerConfig,
    this.onDisposed,
    this.onWillPop,
    this.systemUiOverlayStyle,
    this.animationBuilder,
    this.autoDispose = true,
    required String routeName,
    bool fullscreenDialog = false,
    bool maintainState = true,
  })  : // 要么同时设置泛型B和bloc参数, 要么就都不设置
        assert((B != BLoC && bloc != null) || (B == BLoC && bloc == null)),
        super(
          fullscreenDialog: fullscreenDialog,
          maintainState: maintainState,
          builder: (context) => screen,
          settings: RouteSettings(name: routeName),
        );

  /// 直接传递的BLoC
  final B? bloc;

  /// child
  final Widget screen;

  /// 是否自动关闭输入法
  final bool autoCloseKeyboard;

  /// 初始化方法
  ///
  /// [init]与[onLateinit]设计目的是[init]用来设置静态数据, [onLateinit]设置网络请求数据.
  /// 因为在使用lateinit的过程中, 发现如果widget中需要在初始化的时候用到静态数据, 由于lateinit的缘故
  /// 会导致拿不到静态数据, 所以这里区分一下静态的初始化和动态的初始化(网络请求数据)
  final _OnInit<B>? init;

  /// 入场动画结束后的初始化方法
  final _OnLateInit<B>? onLateinit;

  /// 是否执行动画
  final bool animate;

  /// 是否带有表单
  final bool withForm;

  /// 是否局部navigator
  final bool withLocalNavigator;

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

  /// 是否已经初始化
  bool _inited = false;

  @override
  Widget buildPage(
    BuildContext context,
    Animation<double> animation,
    Animation<double> secondaryAnimation,
  ) {
    Widget result = builder(context);

    if (withLocalNavigator) {
      final tempResult = result;
      result = LocalNavigator(builder: (_) => tempResult);
    }

    if (bloc != null) {
      result = BLoCProvider<B>(
        bloc: bloc!,
        init: init,
        child: result,
        onDispose: onDisposed,
        autoDispose: autoDispose,
      );
    }

    // 是否自动收起键盘
    if (autoCloseKeyboard) {
      result = AutoCloseKeyboard(child: result);
    }

    // 是否带有表单
    if (withForm) {
      result = Form(child: result);
    }

    if (tabControllerConfig != null) {
      result = DefaultTabController(
        length: tabControllerConfig!.length,
        initialIndex: tabControllerConfig!.initialIndex,
        child: result,
      );
    }

    if (systemUiOverlayStyle != null) {
      // 自动对暗黑模式做切换
      SystemUiOverlayStyle style = systemUiOverlayStyle!;
      if (context.isDarkMode) {
        if (style == SystemUiOverlayStyle.dark) {
          style = SystemUiOverlayStyle.light;
        } else if (style == SystemUiOverlayStyle.light) {
          style = SystemUiOverlayStyle.dark;
        }
      }
      result = AnnotatedRegion<SystemUiOverlayStyle>(
        value: style,
        child: result,
      );
    }

    if (onWillPop != null) {
      result = WillPopScope(child: result, onWillPop: onWillPop);
    }

    return Material(
      key: settings.name == null ? null : Key(settings.name!),
      child: result,
    );
  }

  @override
  Widget buildTransitions(
    BuildContext context,
    Animation<double> animation,
    Animation<double> secondaryAnimation,
    Widget child,
  ) {
    animation.addStatusListener((status) {
      // 如果是懒加载, 那么动画结束时开始初始化
      if (status == AnimationStatus.completed &&
          onLateinit != null &&
          bloc != null &&
          !_inited) {
        onLateinit!(bloc!, context);
        _inited = true;
      }
    });

    if (animate) {
      if (animationBuilder != null) {
        return animationBuilder!(animation, child);
      } else {
        return super.buildTransitions(
          context,
          animation,
          secondaryAnimation,
          child,
        );
      }
    } else {
      return child;
    }
  }
}

class DecoratedCupertinoRoute<B extends BLoC, T extends Object>
    extends CupertinoPageRoute<T> {
  DecoratedCupertinoRoute({
    Key? key,
    required this.screen,
    this.bloc,
    this.autoCloseKeyboard = true,
    this.init,
    this.animate = true,
    this.onLateinit,
    this.withForm = false,
    this.withAnalytics = true,
    this.tabControllerConfig,
    this.onDisposed,
    this.onWillPop,
    this.systemUiOverlayStyle,
    this.autoDispose = true,
    required String routeName,
    bool fullscreenDialog = false,
    bool maintainState = true,
  })  : // 要么同时设置泛型B和bloc参数, 要么就都不设置
        assert((B != BLoC && bloc != null) || (B == BLoC && bloc == null)),
        super(
          fullscreenDialog: fullscreenDialog,
          maintainState: maintainState,
          builder: (context) => screen,
          settings: RouteSettings(name: routeName),
        );

  /// 直接传递的BLoC
  final B? bloc;

  /// child
  final Widget screen;

  /// 是否自动关闭输入法
  final bool autoCloseKeyboard;

  /// 初始化方法
  final _OnInit<B>? init;

  /// 是否执行动画
  final bool animate;

  /// 入场动画结束后的初始化方法
  final _OnInit<B>? onLateinit;

  /// 是否带有表单
  final bool withForm;

  /// 是否分析页面并上传
  final bool withAnalytics;

  /// 如果需要TabBar, 则配置这个对象
  final TabControllerConfig? tabControllerConfig;

  final VoidCallback? onDisposed;

  final WillPopCallback? onWillPop;

  /// 系统ui
  final SystemUiOverlayStyle? systemUiOverlayStyle;

  /// 是否自动dispose BLoC
  final bool autoDispose;

  /// 是否已经初始化
  bool _inited = false;

  @override
  Widget buildPage(
    BuildContext context,
    Animation<double> animation,
    Animation<double> secondaryAnimation,
  ) {
    Widget result;
    if (bloc != null) {
      result = BLoCProvider<B>(
        bloc: bloc!,
        init: init,
        child: builder(context),
        onDispose: onDisposed,
        autoDispose: autoDispose,
      );
    } else {
      result = builder(context);
    }

    // 是否自动收起键盘
    if (autoCloseKeyboard) {
      result = AutoCloseKeyboard(child: result);
    }

    // 是否带有表单
    if (withForm) {
      result = Form(child: result);
    }

    if (tabControllerConfig != null) {
      result = DefaultTabController(
        length: tabControllerConfig!.length,
        initialIndex: tabControllerConfig!.initialIndex,
        child: result,
      );
    }

    if (systemUiOverlayStyle != null) {
      // 自动对暗黑模式做切换
      SystemUiOverlayStyle style = systemUiOverlayStyle!;
      if (context.isDarkMode) {
        if (style == SystemUiOverlayStyle.dark) {
          style = SystemUiOverlayStyle.light;
        } else if (style == SystemUiOverlayStyle.light) {
          style = SystemUiOverlayStyle.dark;
        }
      }
      result = AnnotatedRegion<SystemUiOverlayStyle>(
        value: style,
        child: result,
      );
    }

    if (onWillPop != null) {
      result = WillPopScope(child: result, onWillPop: onWillPop);
    }

    return Material(
      key: settings.name == null ? null : Key(settings.name!),
      child: result,
    );
  }

  @override
  Widget buildTransitions(BuildContext context, Animation<double> animation,
      Animation<double> secondaryAnimation, Widget child) {
    animation.addStatusListener((status) {
      // 如果是懒加载, 那么动画结束时开始初始化
      if (status == AnimationStatus.completed &&
          onLateinit != null &&
          bloc != null &&
          !_inited) {
        onLateinit!(bloc!);
        _inited = true;
      }
    });
    return animate
        ? super.buildTransitions(context, animation, secondaryAnimation, child)
        : child;
  }
}
