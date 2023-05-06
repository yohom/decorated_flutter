import 'package:decorated_flutter/decorated_flutter.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';

/// [B]是指定的BLoC, [T]是Route的返回类型
class DecoratedRoute<B extends BLoC, T> extends MaterialPageRoute<T> {
  DecoratedRoute({
    Key? key,
    required this.screen,
    B? bloc,
    this.autoCloseKeyboard = const CloseKeyboardConfig(),
    this.init,
    this.onLateinit,
    this.animate = true,
    this.withForm = false,
    this.withLocalNavigator = false,
    this.tabControllerConfig,
    this.onDisposed,
    this.onWillPop,
    this.systemUiOverlayStyle,
    this.animationBuilder,
    this.autoDispose = true,
    this.decorationBuilder,
    this.backgroundBuilder,
    this.primaryScrollControllerConfig,
    required String routeName,
    bool fullscreenDialog = false,
    bool maintainState = true,
  })  : _bloc = bloc ?? get(), // 如果没有显式指定就从DI容器寻找
        super(
          fullscreenDialog: fullscreenDialog,
          maintainState: maintainState,
          builder: (context) => screen,
          settings: RouteSettings(name: routeName),
        );

  /// 直接传递的BLoC
  final B? _bloc;

  /// child
  final Widget screen;

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
  final bool withLocalNavigator;

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
  final Widget Function(BuildContext)? backgroundBuilder;

  /// 是否已经初始化
  bool _isInitialized = false;

  @override
  Widget buildPage(
    BuildContext context,
    Animation<double> animation,
    Animation<double> secondaryAnimation,
  ) {
    if (onLateinit != null && _bloc != null && !_isInitialized) {
      onLateinit!(_bloc!, context);
      _isInitialized = true;
    }

    Widget result = builder(context);

    if (withLocalNavigator) {
      final tempResult = result;
      result = LocalNavigator(builder: (_) => tempResult);
    }

    if (_bloc != null) {
      result = BLoCProvider<B>(
        bloc: _bloc!,
        init: init,
        onDispose: onDisposed,
        autoDispose: autoDispose,
        child: result,
      );
    }

    // 是否自动收起键盘
    if (autoCloseKeyboard != null) {
      result = AutoCloseKeyboard(
        config: autoCloseKeyboard!,
        child: result,
      );
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

    if (primaryScrollControllerConfig != null) {
      result = PrimaryScrollController(
        controller:
            primaryScrollControllerConfig!.controller ?? ScrollController(),
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
      result = WillPopScope(onWillPop: onWillPop, child: result);
    }

    if (decorationBuilder != null) {
      result = DecoratedBox(
        decoration: decorationBuilder!.call(context),
        child: result,
      );
    }

    if (backgroundBuilder != null) {
      result = Stack(children: [backgroundBuilder!.call(context), result]);
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
          _bloc != null &&
          !_isInitialized) {
        onLateinit!(_bloc!, context);
        _isInitialized = true;
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

/// [B]是指定的BLoC, [T]是Route的返回类型
class DecoratedDialogRoute<B extends BLoC, T> extends DialogRoute<T> {
  DecoratedDialogRoute({
    Key? key,
    required this.dialog,
    B? bloc,
    this.autoCloseKeyboard = const CloseKeyboardConfig(),
    this.init,
    this.onLateinit,
    this.animate = true,
    this.withForm = false,
    this.withLocalNavigator = false,
    this.tabControllerConfig,
    this.onDisposed,
    this.onWillPop,
    this.systemUiOverlayStyle,
    this.animationBuilder,
    this.autoDispose = true,
    this.decorationBuilder,
    this.backgroundBuilder,
    this.primaryScrollControllerConfig,
    super.anchorPoint,
    super.barrierColor,
    super.barrierDismissible,
    super.barrierLabel,
    super.themes,
    super.useSafeArea,
    required String routeName,
  })  : _bloc = bloc ?? get(), // 如果没有显式指定就从DI容器寻找
        super(
          context: gNavigatorKey.currentContext!,
          builder: (context) => dialog,
          settings: RouteSettings(name: routeName),
        );

  /// 直接传递的BLoC
  final B? _bloc;

  /// child
  final Widget dialog;

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
  final bool withLocalNavigator;

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
  final Widget Function(BuildContext)? backgroundBuilder;

  /// 是否已经初始化
  bool _isInitialized = false;

  @override
  Widget buildPage(
    BuildContext context,
    Animation<double> animation,
    Animation<double> secondaryAnimation,
  ) {
    if (onLateinit != null && _bloc != null && !_isInitialized) {
      onLateinit!(_bloc!, context);
      _isInitialized = true;
    }

    Widget result = super.buildPage(context, animation, secondaryAnimation);

    if (withLocalNavigator) {
      final tempResult = result;
      result = LocalNavigator(builder: (_) => tempResult);
    }

    if (_bloc != null) {
      result = BLoCProvider<B>(
        bloc: _bloc!,
        init: init,
        onDispose: onDisposed,
        autoDispose: autoDispose,
        child: result,
      );
    }

    // 是否自动收起键盘
    if (autoCloseKeyboard != null) {
      result = AutoCloseKeyboard(
        config: autoCloseKeyboard!,
        child: result,
      );
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

    if (primaryScrollControllerConfig != null) {
      result = PrimaryScrollController(
        controller:
            primaryScrollControllerConfig!.controller ?? ScrollController(),
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
      result = WillPopScope(onWillPop: onWillPop, child: result);
    }

    if (decorationBuilder != null) {
      result = DecoratedBox(
        decoration: decorationBuilder!.call(context),
        child: result,
      );
    }

    if (backgroundBuilder != null) {
      result = Stack(children: [backgroundBuilder!.call(context), result]);
    }

    return result;
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
          _bloc != null &&
          !_isInitialized) {
        onLateinit!(_bloc!, context);
        _isInitialized = true;
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
