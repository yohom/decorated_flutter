import 'package:flutter/material.dart';

class FractionalScreen extends StatelessWidget {
  const FractionalScreen({
    Key key,
    this.widthFactor = 1.0,
    this.heightFactor = 1.0,
    this.child,
    this.columnChildren,
    this.rowChildren,
    this.direction = Axis.vertical,
    this.scrollable = true,
    this.mainAxisAlignment = MainAxisAlignment.start,
    this.mainAxisSize = MainAxisSize.max,
    this.crossAxisAlignment = CrossAxisAlignment.center,
    this.textDirection,
    this.verticalDirection = VerticalDirection.down,
    this.textBaseline,
    this.padding = EdgeInsets.zero,
    this.safeArea,
    @required this.children,
  }) : super(key: key);

  /// 占屏幕宽度百分比
  final double widthFactor;

  /// 占屏幕高度百分比
  final double heightFactor;

  /// [child], [columnChildren], [rowChildren]三个只能设置一个
  /// 如果都设置了, 那就按[child]->[columnChildren]->[rowChildren]的优先级作为child使用
  /// child
  @Deprecated('使用children')
  final Widget child;

  /// 子控件为Column的children
  @Deprecated('使用children')
  final List<Widget> columnChildren;

  /// 子控件为Row的children
  @Deprecated('使用children')
  final List<Widget> rowChildren;

  /// 不管有一个还是多个child, 都用这个, 然后用[direction]来区分方向
  final List<Widget> children;

  /// 排列方向
  final Axis direction;

  /// 内间距
  final EdgeInsets padding;

  /// 是否可以滚动, 可以配合键盘使用
  final bool scrollable;

  /// 是否Safe Area
  final bool safeArea;

  //region Flex属性
  final MainAxisAlignment mainAxisAlignment;
  final MainAxisSize mainAxisSize;
  final CrossAxisAlignment crossAxisAlignment;
  final TextDirection textDirection;
  final VerticalDirection verticalDirection;
  final TextBaseline textBaseline;

  //endregion

  @override
  Widget build(BuildContext context) {
    Widget content = SizedBox(
      width: MediaQuery.of(context).size.width * widthFactor,
      height: MediaQuery.of(context).size.height * heightFactor,
      child: Padding(
        padding: padding,
        child: Flex(
          direction: direction,
          mainAxisAlignment: mainAxisAlignment,
          mainAxisSize: mainAxisSize,
          crossAxisAlignment: crossAxisAlignment,
          textDirection: textDirection,
          verticalDirection: verticalDirection,
          textBaseline: textBaseline,
          children: children,
        ),
      ),
    );

    if (safeArea != null) {
      content = SafeArea(child: content);
    }

    return scrollable ? SingleChildScrollView(child: content) : content;
  }
}
