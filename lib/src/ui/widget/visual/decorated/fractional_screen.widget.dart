import 'package:material_ui/material_ui.dart';

class FractionalScreen extends StatelessWidget {
  const FractionalScreen({
    super.key,
    this.widthFactor = 1.0,
    this.heightFactor = 1.0,
    this.direction = .vertical,
    this.scrollable = true,
    this.mainAxisAlignment = .start,
    this.mainAxisSize = .max,
    this.crossAxisAlignment = .center,
    this.textDirection,
    this.verticalDirection = .down,
    this.textBaseline,
    this.padding = .zero,
    this.safeArea,
    required this.children,
  });

  /// 占屏幕宽度百分比
  final double widthFactor;

  /// 占屏幕高度百分比
  final double heightFactor;

  /// 不管有一个还是多个child, 都用这个, 然后用[direction]来区分方向
  final List<Widget> children;

  /// 排列方向
  final Axis direction;

  /// 内间距
  final EdgeInsets padding;

  /// 是否可以滚动, 可以配合键盘使用
  final bool scrollable;

  /// 是否Safe Area
  final bool? safeArea;

  //region Flex属性
  final MainAxisAlignment mainAxisAlignment;
  final MainAxisSize mainAxisSize;
  final CrossAxisAlignment crossAxisAlignment;
  final TextDirection? textDirection;
  final VerticalDirection verticalDirection;
  final TextBaseline? textBaseline;

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
