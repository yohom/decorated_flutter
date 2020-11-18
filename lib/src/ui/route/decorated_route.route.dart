import 'package:decorated_flutter/decorated_flutter.dart';
import 'package:decorated_flutter/src/ui/widget/nonvisual/auto_close_keyboard.widget.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:modal_bottom_sheet/modal_bottom_sheet.dart';

typedef void _InitAction<T extends BLoC>(T bloc);

/// [B]是指定的BLoC, [T]是Route的返回类型
class DecoratedRoute<B extends BLoC, T extends Object>
    extends MaterialWithModalsPageRoute<T> {
  DecoratedRoute({
    Key key,
    @required this.screen,
    this.bloc,
    this.autoCloseKeyboard = true,
    this.init,
    this.onLateinit,
    this.animate = true,
    this.withForm = false,
    this.withDefaultTabController = false,
    this.tabLength,
    this.onDispose,
    this.systemUiOverlayStyle,
    this.animationBuilder,
    String routeName,
    bool fullscreenDialog = false,
    bool maintainState = true,
  })  : // 要么同时设置泛型B和bloc参数, 要么就都不设置
        assert((B != BLoC && bloc != null) || (B == BLoC && bloc == null)),
        // 如果withDefaultTabController为true, 那么必须设置tabLength
        assert((withDefaultTabController && tabLength != null) ||
            !withDefaultTabController),
        super(
          fullscreenDialog: fullscreenDialog,
          maintainState: maintainState,
          builder: (context) => screen,
          settings: RouteSettings(name: routeName),
        );

  /// 直接传递的BLoC
  final B bloc;

  /// child
  final Widget screen;

  /// 是否自动关闭输入法
  final bool autoCloseKeyboard;

  /// 初始化方法
  ///
  /// [init]与[onLateinit]设计目的是[init]用来设置静态数据, [onLateinit]设置网络请求数据.
  /// 因为在使用lateinit的过程中, 发现如果widget中需要在初始化的时候用到静态数据, 由于lateinit的缘故
  /// 会导致拿不到静态数据, 所以这里区分一下静态的初始化和动态的初始化(网络请求数据)
  final _InitAction<B> init;

  /// 入场动画结束后的初始化方法
  final _InitAction<B> onLateinit;

  /// 是否执行动画
  final bool animate;

  /// 是否带有表单
  final bool withForm;

  /// 是否含有TabBar
  final bool withDefaultTabController;

  /// tab bar长度, 必须和[withDefaultTabController]一起设置
  final int tabLength;

  final VoidCallback onDispose;

  /// 系统ui
  final SystemUiOverlayStyle systemUiOverlayStyle;

  /// 自定义的动画
  final Widget Function(Animation, Widget) animationBuilder;

  /// 是否已经初始化
  bool _inited = false;

  @override
  Widget buildPage(
    BuildContext context,
    Animation<double> animation,
    Animation<double> secondaryAnimation,
  ) {
    Global.init(context);

    Widget result;
    if (isNotEmpty(bloc)) {
      result = BLoCProvider<B>(
        bloc: bloc,
        init: init,
        child: builder(context),
        onDispose: onDispose,
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

    if (withDefaultTabController) {
      result = DefaultTabController(length: tabLength, child: result);
    }

    if (systemUiOverlayStyle != null) {
      result = AnnotatedRegion(child: result, value: systemUiOverlayStyle);
    }

    return Material(child: result);
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
        onLateinit(bloc);
        _inited = true;
      }
    });

    if (animate) {
      if (animationBuilder != null) {
        return animationBuilder(animation, child);
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
    Key key,
    @required this.screen,
    this.bloc,
    this.autoCloseKeyboard = true,
    this.init,
    this.animate = true,
    this.onLateinit,
    this.withForm = false,
    this.withAnalytics = true,
    this.withDefaultTabController = false,
    this.tabLength,
    this.onDispose,
    this.systemUiOverlayStyle,
    String routeName,
    bool fullscreenDialog = false,
    bool maintainState = true,
  })  : // 要么同时设置泛型B和bloc参数, 要么就都不设置
        assert((B != BLoC && bloc != null) || (B == BLoC && bloc == null)),
        // 如果withDefaultTabController为true, 那么必须设置tabLength
        assert((withDefaultTabController && tabLength != null) ||
            !withDefaultTabController),
        super(
          fullscreenDialog: fullscreenDialog,
          maintainState: maintainState,
          builder: (context) => screen,
          settings: RouteSettings(name: routeName),
        );

  /// 直接传递的BLoC
  final B bloc;

  /// child
  final Widget screen;

  /// 是否自动关闭输入法
  final bool autoCloseKeyboard;

  /// 初始化方法
  final _InitAction<B> init;

  /// 是否执行动画
  final bool animate;

  /// 入场动画结束后的初始化方法
  final _InitAction<B> onLateinit;

  /// 是否带有表单
  final bool withForm;

  /// 是否分析页面并上传
  final bool withAnalytics;

  /// 是否含有TabBar
  final bool withDefaultTabController;

  /// tab bar长度, 必须和[withDefaultTabController]一起设置
  final int tabLength;

  final VoidCallback onDispose;

  /// 系统ui
  final SystemUiOverlayStyle systemUiOverlayStyle;

  /// 是否已经初始化
  bool _inited = false;

  @override
  Widget buildPage(
    BuildContext context,
    Animation<double> animation,
    Animation<double> secondaryAnimation,
  ) {
    Global.init(context);

    Widget result;
    if (isNotEmpty(bloc)) {
      result = BLoCProvider<B>(
        bloc: bloc,
        init: init,
        child: builder(context),
        onDispose: onDispose,
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

    if (withDefaultTabController) {
      result = DefaultTabController(length: tabLength, child: result);
    }

    if (systemUiOverlayStyle != null) {
      result = AnnotatedRegion(child: result, value: systemUiOverlayStyle);
    }

    return Material(child: result);
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
        onLateinit(bloc);
        _inited = true;
      }
    });
    return animate
        ? super.buildTransitions(context, animation, secondaryAnimation, child)
        : child;
  }
}
