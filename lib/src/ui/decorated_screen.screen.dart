import 'dart:async';

import 'package:connectivity/connectivity.dart';
import 'package:decorated_flutter/decorated_flutter.dart';
import 'package:flutter/material.dart';

typedef void _InitAction<T extends BLoC>(T bloc);
typedef void _ConnectivityChangedCallback(
  BuildContext context,
  ConnectivityResult result,
);

/// [B]是指定的BLoC
class DecoratedScreen<B extends BLoC> extends StatefulWidget {
  DecoratedScreen({
    Key key,
    @required this.screen,
    this.bloc,
    this.autoCloseKeyboard = true,
    this.init,
    this.withForm = false,
    this.withAnalytics = true,
    this.withDefaultTabController = false,
    this.tabLength,
    this.onConnectivityChanged,
  })  : // 要么同时设置泛型B和bloc参数, 要么就都不设置
        assert((B != BLoC && bloc != null) || (B == BLoC && bloc == null)),
        // 如果withDefaultTabController为true, 那么必须设置tabLength
        assert((withDefaultTabController && tabLength != null) ||
            !withDefaultTabController),
        super();

  /// 直接传递的BLoC
  final B bloc;

  /// child
  final Widget screen;

  /// 是否自动关闭输入法
  final bool autoCloseKeyboard;

  /// 初始化方法
  final _InitAction<B> init;

  /// 是否带有表单
  final bool withForm;

  /// 是否分析页面并上传
  final bool withAnalytics;

  /// 是否含有TabBar
  final bool withDefaultTabController;

  /// tab bar长度, 必须和[withDefaultTabController]一起设置
  final int tabLength;

  /// 网络连接情况切换回调
  final _ConnectivityChangedCallback onConnectivityChanged;

  @override
  _DecoratedScreenState createState() => _DecoratedScreenState<B>();
}

class _DecoratedScreenState<B extends BLoC> extends State<DecoratedScreen<B>> {
  /// 当前的网络连接状态
  ConnectivityResult _currentState;

  /// 网络状态监听的订阅
  StreamSubscription _subscription;

  @override
  Widget build(BuildContext context) {
    Widget result;
    if (isNotEmpty(widget.bloc)) {
      result = BLoCProvider<B>(
        bloc: widget.bloc,
        init: widget.init,
        withAnalytics: widget.withAnalytics,
        child: widget.screen,
      );
    } else {
      result = widget.screen;
    }

    // 是否自动收起键盘
    if (widget.autoCloseKeyboard) {
      result = AutoCloseKeyboard(child: result);
    }

    // 是否带有表单
    if (widget.withForm) {
      result = Form(child: result);
    }

    if (widget.withDefaultTabController) {
      result = DefaultTabController(length: widget.tabLength, child: result);
    }

    if (widget.onConnectivityChanged != null) {
      _subscription =
          Connectivity().onConnectivityChanged.skip(1).listen((event) {
        if (_currentState != event) {
          _currentState = event;
          widget.onConnectivityChanged(context, _currentState);
        }
      });
    }

    return result;
  }

  @override
  void dispose() {
    _subscription?.cancel();
    super.dispose();
  }
}
