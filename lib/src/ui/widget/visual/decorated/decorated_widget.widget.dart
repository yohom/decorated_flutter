import 'dart:io';

import 'package:decorated_flutter/decorated_flutter.dart';
import 'package:decorated_flutter/src/ui/widget/nonvisual/auto_close_keyboard.widget.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';

typedef void _InitAction<T extends BLoC>(T bloc);

/// [B]是指定的BLoC
class DecoratedWidget<B extends BLoC> extends StatefulWidget {
  DecoratedWidget({
    Key? key,
    required this.widget,
    this.bloc,
    this.autoCloseKeyboard = true,
    this.init,
    this.withForm = false,
    this.systemUiOverlayStyle,
    this.tabControllerConfig,
  })  : // 要么同时设置泛型B和bloc参数, 要么就都不设置
        assert((B != BLoC && bloc != null) || (B == BLoC && bloc == null)),
        super();

  /// 直接传递的BLoC
  final B? bloc;

  /// child
  final Widget widget;

  /// 是否自动关闭输入法
  final bool autoCloseKeyboard;

  /// 初始化方法
  final _InitAction<B>? init;

  /// 是否带有表单
  final bool withForm;

  /// 系统ui
  final SystemUiOverlayStyle? systemUiOverlayStyle;

  /// 如果需要TabBar, 则配置这个对象
  final TabControllerConfig? tabControllerConfig;

  @override
  _DecoratedWidgetState createState() => _DecoratedWidgetState<B>();
}

class _DecoratedWidgetState<B extends BLoC> extends State<DecoratedWidget<B>> {
  @override
  Widget build(BuildContext context) {
    Widget result;
    if (widget.bloc != null) {
      result = BLoCProvider<B>(
        bloc: widget.bloc!,
        init: widget.init,
        child: widget.widget,
      );
    } else {
      result = widget.widget;
    }

    // 是否自动收起键盘
    if (widget.autoCloseKeyboard == true) {
      result = AutoCloseKeyboard(child: result);
    }

    // 是否带有表单
    if (widget.withForm == true) {
      result = Form(child: result);
    }

    if (widget.tabControllerConfig != null) {
      result = DefaultTabController(
        length: widget.tabControllerConfig!.length,
        initialIndex: widget.tabControllerConfig!.initialIndex,
        child: result,
      );
    }

    if (widget.systemUiOverlayStyle != null) {
      // 自动对暗黑模式做切换
      SystemUiOverlayStyle style = widget.systemUiOverlayStyle!;
      if (Platform.isIOS) {
        if (context.isDarkMode) {
          if (style == SystemUiOverlayStyle.dark) {
            style = SystemUiOverlayStyle.light;
          } else if (style == SystemUiOverlayStyle.light) {
            style = SystemUiOverlayStyle.dark;
          }
        }
      }
      result = AnnotatedRegion<SystemUiOverlayStyle>(
        value: style,
        child: result,
      );
    }

    return result;
  }
}
