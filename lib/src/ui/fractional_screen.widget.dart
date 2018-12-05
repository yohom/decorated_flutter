import 'package:flutter/material.dart';
import 'package:decorated_flutter/framework.dart';

class FractionalScreen extends StatelessWidget {
  const FractionalScreen({
    Key key,
    this.widthFactor = 1.0,
    this.heightFactor = 1.0,
    this.child,
    this.columnChildren,
    this.rowChildren,
    this.scrollable = true,
  })  : assert((child != null &&
                rowChildren == null &&
                columnChildren == null) ||
            (child == null && rowChildren != null && columnChildren == null) ||
            (child == null && rowChildren == null && columnChildren != null)),
        super(key: key);

  /// 占屏幕宽度百分比
  final double widthFactor;

  /// 占屏幕高度百分比
  final double heightFactor;

  /// [child], [columnChildren], [rowChildren]三个只能设置一个
  /// 如果都设置了, 那就按[child]->[columnChildren]->[rowChildren]的优先级作为child使用
  /// child
  final Widget child;

  /// 子控件为Column的children
  final List<Widget> columnChildren;

  /// 子控件为Row的children
  final List<Widget> rowChildren;

  /// 是否可以滚动, 可以配合键盘使用
  final bool scrollable;

  @override
  Widget build(BuildContext context) {
    final content = SizedBox(
      width: Global.screenWidth * widthFactor,
      height: Global.screenHeight * heightFactor,
      child: child ??
          Column(children: columnChildren) ??
          Row(children: rowChildren),
    );
    return scrollable ? SingleChildScrollView(child: content) : content;
  }
}
