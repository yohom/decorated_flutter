import 'package:decorated_flutter/decorated_flutter.dart';
import 'package:decorated_flutter/src/ui/widget/nonvisual/auto_close_keyboard.widget.dart';
import 'package:flutter/material.dart';

typedef void _InitAction<T extends BLoC>(T bloc);

/// [B]是指定的BLoC, [T]是Route的返回类型
class DecoratedRoute<B extends BLoC, T extends Object>
    extends MaterialPageRoute<T> {
  DecoratedRoute({
    Key key,
    @required this.screen,
    this.bloc,
    this.autoCloseKeyboard = true,
    this.init,
    this.animate = true,
    this.lateinit = false,
    this.withForm = false,
    this.withAnalytics = true,
    this.withDefaultTabController = false,
    this.tabLength,
    this.onDispose,
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

  /// 是否等待入场动画结束之后再进行初始化动作
  final bool lateinit;

  /// 是否带有表单
  final bool withForm;

  /// 是否分析页面并上传
  final bool withAnalytics;

  /// 是否含有TabBar
  final bool withDefaultTabController;

  /// tab bar长度, 必须和[withDefaultTabController]一起设置
  final int tabLength;

  final VoidCallback onDispose;

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
        init: lateinit ? null : init, // 可以设置为null, BLoCProvider会处理的
        withAnalytics: withAnalytics,
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

    return Material(child: result);
  }

  @override
  Widget buildTransitions(BuildContext context, Animation<double> animation,
      Animation<double> secondaryAnimation, Widget child) {
    animation.addStatusListener((status) {
      // 如果是懒加载, 那么动画结束时开始初始化
      if (status == AnimationStatus.completed &&
          lateinit &&
          init != null &&
          bloc != null &&
          !_inited) {
        init(bloc);
        _inited = true;
      }
    });
    return animate
        ? super.buildTransitions(context, animation, secondaryAnimation, child)
        : child;
  }
}
