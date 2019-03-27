import 'package:decorated_flutter/decorated_flutter.dart';
import 'package:flutter/material.dart';

class ShadowedBox extends StatelessWidget {
  /// 内部Container的width
  final double width;

  /// 内部Container的height
  final double height;

  /// shadow的偏移量
  final Offset shadowOffset;

  /// 内部shadow的blurRadius, 控制阴影的发散程度, 值越大, 就越发散, 越不集中
  final double blurRadius;

  /// 内部shadow的spreadRadius, 目前观察来看如果设置成负数, 就可以使阴影比child小
  final double spreadRadius;

  /// shadow的颜色
  final Color shadowColor;

  /// 内部Container的shape, 默认为[BoxShape.rectangle]
  final BoxShape shape;

  /// 内部Container的border
  final Border border;

  /// 内部Container的borderRadius
  final BorderRadius borderRadius;

  /// 内部Container的背景颜色
  final Color color;

  /// 内部Container的margin
  final EdgeInsetsGeometry margin;

  /// 内部Container的padding
  final EdgeInsetsGeometry padding;
  final Widget child;

  const ShadowedBox({
    Key key,
    this.width,
    this.height,
    this.shadowOffset = const Offset(.0, 8.0),
    this.blurRadius = 8.0,
    this.spreadRadius = 0.0,
    this.shadowColor = Colors.black26,
    this.shape = BoxShape.rectangle,
    this.border,
    this.borderRadius,
    this.color = Colors.white,
    this.margin = const EdgeInsets.all(kSpaceSmall),
    this.padding,
    this.child,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Container(
      width: width,
      height: height,
      margin: margin,
      padding: padding,
      decoration: BoxDecoration(
        color: color,
        shape: shape,
        border: border,
        borderRadius: borderRadius,
        boxShadow: [
          BoxShadow(
            color: shadowColor,
            offset: shadowOffset,
            blurRadius: blurRadius,
            spreadRadius: spreadRadius,
          )
        ],
      ),
      child: child,
    );
  }
}
