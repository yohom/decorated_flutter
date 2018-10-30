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

    // 如果需要运行时信息不为空的话就加一层运行时信息显示
    // release模式任何情况下都不允许出现调试信息
    if (isNotEmpty(runtimeInfo) && !bool.fromEnvironment('dart.vm.product')) {
      Overlay.of(context).insert(
        OverlayEntry(
          builder: (context) {
            return Positioned(
              bottom: kSpaceNormal,
              child: Container(
                height: Global.screenHeight / 3,
                width: Global.screenWidth,
                color: Colors.grey.withOpacity(0.6),
                child: ListView.builder(
                  shrinkWrap: true,
                  itemCount: runtimeInfo.length,
                  itemBuilder: (context, index) {
                    final event = runtimeInfo[index];
                    return StreamBuilder(
                      stream: event.stream,
                      builder: (_, __) {
                        return Text(event.runtimeSummary());
                      },
                    );
                  },
                ),
              ),
            );
          },
        ),
      );
    }
    return result;
  }
}
