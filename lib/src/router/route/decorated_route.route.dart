import 'package:flutter/material.dart';
import 'package:framework/framework.dart';

typedef void _InitAction<T extends BLoC>(T bloc);

class DecoratedRoute<B extends BLoC> extends MaterialPageRoute {
  DecoratedRoute({
    Key key,
    @required this.screen,
    this.bloc,
    this.autoCloseKeyboard = true,
    this.init,
    this.runtimeInfo,
    String routeName,
    bool isInitialRoute = false,
  })  : assert((B != BLoC && bloc != null) ||
            (B == BLoC && bloc == null)), // 要么同时设置泛型B和bloc参数, 要么就都不设置
        super(
          builder: (context) => screen,
          settings: RouteSettings(
            name: routeName,
            isInitialRoute: isInitialRoute,
          ),
        );

  /// 直接传递的BLoC
  final B bloc;

  /// child
  final Widget screen;

  /// 是否自动关闭输入法
  final bool autoCloseKeyboard;

  /// 初始化方法
  final _InitAction<B> init;

  /// 运行时的一些信息
  final List<Event> runtimeInfo;

  @override
  Widget buildPage(
    BuildContext context,
    Animation<double> animation,
    Animation<double> secondaryAnimation,
  ) {
    if (settings.isInitialRoute) {
      Global.init(context);
    }

    Widget result;
    if (isNotEmpty(bloc)) {
      result = BLoCProvider<B>(
        bloc: bloc,
        init: init,
        child: autoCloseKeyboard
            ? AutoCloseKeyboard(child: builder(context))
            : builder(context),
      );
    } else {
      result = autoCloseKeyboard
          ? AutoCloseKeyboard(child: builder(context))
          : builder(context);
    }
    return result;
  }
}
