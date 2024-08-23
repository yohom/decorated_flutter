import 'package:decorated_flutter/decorated_flutter.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';

/// [B]是指定的BLoC
class DecoratedWidget<B extends BLoC> extends StatefulWidget {
  const DecoratedWidget({
    super.key,
    required this.widget,
    this.bloc,
    this.autoCloseKeyboard = true,
    this.canDispose = returnTrue,
    this.init,
    this.onLateinit,
    this.withForm = false,
    this.systemUiOverlayStyle,
    this.tabControllerConfig,
    this.decorationBuilder,
    this.onDispose,
  });

  /// 直接传递的BLoC
  final B? bloc;

  /// child
  final Widget widget;

  /// 是否自动关闭输入法
  final bool autoCloseKeyboard;

  /// 是否自动释放BLoC
  final bool Function() canDispose;

  /// 初始化方法
  final InitCallback<B>? init;

  /// 懒加载
  final LateInitCallback<B>? onLateinit;

  /// 是否带有表单
  final bool withForm;

  /// 系统ui
  final SystemUiOverlayStyle? systemUiOverlayStyle;

  /// 如果需要TabBar, 则配置这个对象
  final TabControllerConfig? tabControllerConfig;

  /// 自定义的样式
  final BoxDecoration Function(BuildContext)? decorationBuilder;

  /// dispose回调
  final VoidCallback? onDispose;

  @override
  _DecoratedWidgetState createState() => _DecoratedWidgetState<B>();
}

class _DecoratedWidgetState<B extends BLoC> extends State<DecoratedWidget<B>> {
  @override
  void initState() {
    super.initState();
    if (widget.onLateinit != null && widget.bloc != null) {
      WidgetsBinding.instance.addPostFrameCallback((_) {
        if (mounted) {
          widget.onLateinit!(widget.bloc!, context);
        }
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    Widget result;

    B? bloc = widget.bloc;
    if (bloc != null) {
      result = BLoCProvider<B>(
        bloc: bloc,
        init: widget.init,
        canDispose: widget.canDispose,
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

    if (widget.decorationBuilder != null) {
      result = DecoratedBox(
        decoration: widget.decorationBuilder!.call(context),
        child: result,
      );
    }

    return result;
  }

  @override
  void dispose() {
    widget.onDispose?.call();
    super.dispose();
  }
}
