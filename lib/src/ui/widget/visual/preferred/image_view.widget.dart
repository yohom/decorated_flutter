import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';

typedef void LoadingProgress(double progress, List<int> data);

class ImageView extends StatelessWidget {
  ImageView.asset(
    this.imagePath, {
    Key key,
    this.width,
    this.height,
    this.size,
    this.fit,
    this.color,
  })  : imageUrl = null,
        errorWidget = null,
        placeholder = const SizedBox.shrink(),
        super(key: key);

  ImageView.network(
    this.imageUrl, {
    Key key,
    this.width,
    this.height,
    this.size,
    this.fit,
    this.color,
    this.errorWidget,
    this.placeholder = const SizedBox.shrink(),
  })  : imagePath = null,
        super(key: key);

  /// 本地图片路径
  final String imagePath;

  /// 图片url
  final String imageUrl;

  /// 宽度 如果同时设置了[width], [height]和[size], 那么优先[size]
  final double width;

  /// 高度 如果同时设置了[width], [height]和[size], 那么优先[size]
  final double height;

  /// 适应模式
  final BoxFit fit;

  /// 颜色
  final Color color;

  /// 备用的asset image路径
  final Widget errorWidget;

  /// 大小, 如果同时设置了[width], [height]和[size], 那么优先[size]
  final double size;

  /// 占位图
  final Widget placeholder;

  @override
  Widget build(BuildContext context) {
    if (imagePath != null) {
      return Image.asset(
        imagePath,
        width: size ?? width,
        height: size ?? height,
        fit: fit,
        color: color,
        gaplessPlayback: true,
      );
    } else if (imageUrl != null) {
      return CachedNetworkImage(
        imageUrl: imageUrl,
        width: size ?? width,
        height: size ?? height,
        fit: fit,
        color: color,
        placeholder: (_, __) => placeholder,
        errorWidget: (_, __, ___) => errorWidget,
      );
    } else {
      // 如果图片地址为null的话, 那就不显示
      return SizedBox.shrink();
    }
  }
}
