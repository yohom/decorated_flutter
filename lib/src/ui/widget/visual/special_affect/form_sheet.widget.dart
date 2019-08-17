import 'package:flutter/material.dart';

/// 表单Widget
/// 1. 自带提交按钮, 可以自定义样式
/// 2. 可以区分滚动和不能滚动
class FormSheet extends StatelessWidget {
  const FormSheet({
    Key key,
    this.scrollable = false,
    this.submit,
    this.autovalidate = false,
    this.onWillPop,
    this.onChanged,
    @required this.children,
  }) : super(key: key);

  /// 是否可以滚动, 如果是, 那么内部会使用[ListView], 如果不是, 内部会使用[Column]
  final bool scrollable;

  /// 提交回调
  final Widget submit;

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
    children.add(submit);
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
