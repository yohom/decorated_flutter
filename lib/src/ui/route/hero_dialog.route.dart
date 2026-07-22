import 'package:flutter/material.dart';

/// 支持 Hero 转场的透明弹窗路由
class HeroDialogRoute<T> extends PageRoute<T> {
  /// 创建支持 Hero 动画的弹窗路由
  HeroDialogRoute({
    required this.builder,
    this.barrierDismissible = true,
    this.barrierColor = Colors.black54,
    this.barrierLabel = '关闭弹窗',
    this.useSafeArea = true,
    this.transitionOffset = const Offset(0, 20),
    this.transitionDuration = const Duration(milliseconds: 200),
    this.reverseTransitionDuration = const Duration(milliseconds: 160),
    this.curve = Curves.easeOut,
    this.reverseCurve = Curves.easeIn,
    super.settings,
  }) : assert(!barrierDismissible || barrierLabel != null);

  /// 弹窗内容构造器
  final WidgetBuilder builder;

  /// 是否允许点击遮罩关闭弹窗
  @override
  final bool barrierDismissible;

  /// 弹窗遮罩颜色
  @override
  final Color? barrierColor;

  /// 弹窗遮罩的无障碍描述
  @override
  final String? barrierLabel;

  /// 是否为弹窗内容添加安全区域
  final bool useSafeArea;

  /// 弹窗进入和退出时的位移距离
  final Offset transitionOffset;

  /// 弹窗进入动画时长
  @override
  final Duration transitionDuration;

  /// 弹窗退出动画时长
  @override
  final Duration reverseTransitionDuration;

  /// 弹窗进入动画曲线
  final Curve curve;

  /// 弹窗退出动画曲线
  final Curve reverseCurve;

  CurvedAnimation? _curvedAnimation;

  @override
  bool get opaque => false;

  @override
  bool get maintainState => true;

  @override
  void dispose() {
    _curvedAnimation?.dispose();
    super.dispose();
  }

  @override
  Widget buildPage(
    BuildContext context,
    Animation<double> animation,
    Animation<double> secondaryAnimation,
  ) {
    final child = Center(child: builder(context));
    return useSafeArea ? SafeArea(child: child) : child;
  }

  @override
  Widget buildTransitions(
    BuildContext context,
    Animation<double> animation,
    Animation<double> secondaryAnimation,
    Widget child,
  ) {
    final curvedAnimation = _curvedAnimation ??= CurvedAnimation(
      parent: animation,
      curve: curve,
      reverseCurve: reverseCurve,
    );

    return AnimatedBuilder(
      animation: curvedAnimation,
      builder: (_, child) {
        return Opacity(
          opacity: curvedAnimation.value,
          child: Transform.translate(
            offset: transitionOffset * (1 - curvedAnimation.value),
            child: child,
          ),
        );
      },
      child: child,
    );
  }
}

/// 打开支持 Hero 动画的透明弹窗
Future<T?> showHeroDialog<T>(
  BuildContext context, {
  required WidgetBuilder builder,
  bool useRootNavigator = false,
  bool barrierDismissible = true,
  Color? barrierColor = Colors.black54,
  String? barrierLabel = '关闭弹窗',
  bool useSafeArea = true,
  Offset transitionOffset = const Offset(0, 20),
  Duration transitionDuration = const Duration(milliseconds: 200),
  Duration reverseTransitionDuration = const Duration(milliseconds: 160),
  Curve curve = Curves.easeOut,
  Curve reverseCurve = Curves.easeIn,
}) {
  return Navigator.of(context, rootNavigator: useRootNavigator).push<T>(
    HeroDialogRoute<T>(
      builder: builder,
      barrierDismissible: barrierDismissible,
      barrierColor: barrierColor,
      barrierLabel: barrierLabel,
      useSafeArea: useSafeArea,
      transitionOffset: transitionOffset,
      transitionDuration: transitionDuration,
      reverseTransitionDuration: reverseTransitionDuration,
      curve: curve,
      reverseCurve: reverseCurve,
    ),
  );
}
