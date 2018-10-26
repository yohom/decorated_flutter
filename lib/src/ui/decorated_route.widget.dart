import 'package:flutter/material.dart';
import 'package:framework/framework.dart';
import 'package:kiwi/kiwi.dart' as kiwi;

typedef void _InitAction<T extends BLoC>(T bloc);

class DecoratedRoute<B extends BLoC> extends MaterialPageRoute {
  DecoratedRoute({
    Key key,
    @required this.screen,
    this.bloc,
    this.autoCloseKeyboard = true,
    this.init,
    String routeName,
    bool isInitialRoute = false,
  }) : super(
          builder: (context) => screen,
          settings: RouteSettings(
            name: routeName,
            isInitialRoute: isInitialRoute,
          ),
        );

  /// 直接传递的BLoC, 如果没有设置, 那么就去kiwi里去获取
  final B bloc;

  /// child
  final Widget screen;

  /// 是否自动关闭输入法
  final bool autoCloseKeyboard;

  /// 初始化方法
  final _InitAction<B> init;

  @override
  Widget buildPage(
    BuildContext context,
    Animation<double> animation,
    Animation<double> secondaryAnimation,
  ) {
    if (settings.isInitialRoute) {
      Global.init(context);
    }

    B _bloc;
    // 优先使用参数里传递的BLoC
    if (bloc != null) {
      _bloc = bloc;
    } else if (B != BLoC) {
      // 说明BLoC泛型被设置, 那么去kiwi里去获取实例
      _bloc = kiwi.Container().resolve();
    }

    Widget result;
    if (isNotEmpty(_bloc)) {
      result = BLoCProvider<B>(
        bloc: _bloc,
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
