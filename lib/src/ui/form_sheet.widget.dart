import 'package:flutter/material.dart';

typedef void _OnSubmit(BuildContext context);

/// 表单Widget
/// 1. 自带提交按钮, 可以自定义样式
/// 2. 可以区分滚动和不能滚动
class FormSheet extends StatelessWidget {
  const FormSheet({
    Key key,
    this.scrollable = false,
    this.submitDecoration = const SubmitDecoration(),
    this.onSubmit,
    this.autovalidate = false,
    this.onWillPop,
    this.onChanged,
    @required this.children,
  }) : super(key: key);

  /// 是否可以滚动, 如果是, 那么内部会使用[ListView], 如果不是, 内部会使用[Column]
  final bool scrollable;

  /// 提交按钮的样式, 用的就是[RaisedButton]的样式
  final SubmitDecoration submitDecoration;

  /// 提交回调
  final _OnSubmit onSubmit;

  /// 是否自动检查, 传递给内部[Form]
  final bool autovalidate;

  /// 传递给内部[Form]
  final WillPopCallback onWillPop;

  /// 传递给内部[Form]
  final VoidCallback onChanged;

  /// children列表
  final List<Widget> children;

  @override
  Widget build(BuildContext context) {
    final children = <Widget>[];
    children.addAll(this.children);
    children.add(RaisedButton(
      onPressed: () => onSubmit(context),
      textTheme: submitDecoration.textTheme,
      textColor: submitDecoration.textColor,
      disabledTextColor: submitDecoration.disabledTextColor,
      color: submitDecoration.color,
      disabledColor: submitDecoration.disabledColor,
      highlightColor: submitDecoration.highlightColor,
      splashColor: submitDecoration.splashColor,
      colorBrightness: submitDecoration.colorBrightness,
      elevation: submitDecoration.elevation,
      highlightElevation: submitDecoration.highlightElevation,
      disabledElevation: submitDecoration.disabledElevation,
      padding: submitDecoration.padding,
      shape: submitDecoration.shape,
      clipBehavior: submitDecoration.clipBehavior,
      materialTapTargetSize: submitDecoration.materialTapTargetSize,
      animationDuration: submitDecoration.animationDuration,
    ));
    return Form(
      autovalidate: autovalidate,
      onWillPop: onWillPop,
      onChanged: onChanged,
      child: scrollable
          ? ListView(children: children)
          : Column(children: children),
    );
  }
}

/// 照搬了[RaisedButton]的参数列表
class SubmitDecoration {
  const SubmitDecoration({
    this.textTheme,
    this.textColor,
    this.disabledTextColor,
    this.color,
    this.disabledColor,
    this.highlightColor,
    this.splashColor,
    this.colorBrightness,
    this.elevation = 2.0,
    this.highlightElevation = 8.0,
    this.disabledElevation = 0.0,
    this.padding,
    this.shape,
    this.clipBehavior = Clip.none,
    this.materialTapTargetSize,
    this.animationDuration = kThemeChangeDuration,
  });

  final ButtonTextTheme textTheme;

  final Color textColor;

  final Color disabledTextColor;

  final Color color;

  final Color disabledColor;

  final Color splashColor;

  final Color highlightColor;

  final double elevation;

  final double highlightElevation;

  final double disabledElevation;

  final Brightness colorBrightness;

  final EdgeInsetsGeometry padding;

  final ShapeBorder shape;

  final Clip clipBehavior;

  final Duration animationDuration;

  final MaterialTapTargetSize materialTapTargetSize;
}
