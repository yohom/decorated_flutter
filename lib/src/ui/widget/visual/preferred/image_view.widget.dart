import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';
import 'package:flutter_svg/svg.dart';

typedef void LoadingProgress(double progress, List<int> data);

class ImageView extends StatelessWidget {
  ImageView.asset(
    this.imagePath, {
    Key? key,
    this.width,
    this.height,
    this.size,
    this.fit,
    this.color,
    this.padding,
    this.margin,
  })  : imageUrl = null,
        errorWidget = const SizedBox.shrink(),
        placeholder = const SizedBox.shrink(),
        super(key: key);

  ImageView.network(
    this.imageUrl, {
    Key? key,
    this.width,
    this.height,
    this.size,
    this.fit,
    this.color,
    this.errorWidget = const SizedBox.shrink(),
    this.placeholder = const SizedBox.shrink(),
    this.padding,
    this.margin,
  })  : imagePath = null,
        super(key: key);

  /// 本地图片路径
  final String? imagePath;

  /// 图片url
  final String? imageUrl;

  /// 宽度 如果同时设置了[width], [height]和[size], 那么优先[size]
  final double? width;

  /// 高度 如果同时设置了[width], [height]和[size], 那么优先[size]
  final double? height;

  /// 适应模式
  final BoxFit? fit;

  /// 颜色
  final Color? color;

  /// 备用的asset image路径
  final Widget errorWidget;

  /// 大小, 如果同时设置了[width], [height]和[size], 那么优先[size]
  final double? size;

  /// 占位图
  final Widget placeholder;

  /// 内边距
  final EdgeInsets? padding;

  /// 外边距
  final EdgeInsets? margin;

  @override
  Widget build(BuildContext context) {
    Widget result;
    if (imagePath != null) {
      if (imagePath!.endsWith('svg')) {
        result = SvgPicture.asset(
          imagePath!,
          width: size ?? width,
          height: size ?? height,
          fit: fit ?? BoxFit.contain,
          color: color,
          placeholderBuilder: (_) => placeholder,
        );
      } else {
        result = Image.asset(
          imagePath!,
          width: size ?? width,
          height: size ?? height,
          fit: fit,
          color: color,
          gaplessPlayback: true,
        );
      }
    } else if (imageUrl != null) {
      if (imageUrl!.endsWith('svg')) {
        result = SvgPicture.network(
          imageUrl!,
          width: size ?? width,
          height: size ?? height,
          fit: fit ?? BoxFit.contain,
          color: color,
          placeholderBuilder: (_) => placeholder,
        );
      } else {
        result = CachedNetworkImage(
          imageUrl: imageUrl!,
          width: size ?? width,
          height: size ?? height,
          fit: fit,
          color: color,
          placeholder: (_, __) => placeholder,
          errorWidget: (_, __, ___) => errorWidget,
        );
      }
    } else {
      // 如果图片地址为null的话, 那就不显示
      result = SizedBox.shrink();
    }

    if (size != null || width != null || height != null) {
      result = SizedBox(
        width: size ?? width,
        height: size ?? height,
        child: result,
      );
    }

    if (padding != null || margin != null) {
      result = Container(padding: padding, margin: margin, child: result);
    }

    return result;
  }
}
