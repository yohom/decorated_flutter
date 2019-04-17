import 'package:flutter/material.dart';
import 'package:flutter_advanced_networkimage/provider.dart';
import 'package:flutter_svg/flutter_svg.dart';

class ImageView extends StatelessWidget {
  ImageView.assetImage(
    this.imagePath, {
    this.width,
    this.height,
    this.size,
    this.fit = BoxFit.contain,
    this.color,
  })  : imageUrl = null,
        svgPath = null,
        svgUrl = null,
        icon = null,
        useDiskCache = true;

  ImageView.networkImage(
    this.imageUrl, {
    this.width,
    this.height,
    this.size,
    this.fit = BoxFit.contain,
    this.color,
    this.useDiskCache = true,
  })  : imagePath = null,
        svgUrl = null,
        icon = null,
        svgPath = null;

  ImageView.assetSvg(
    this.svgPath, {
    this.width,
    this.height,
    this.size,
    this.fit = BoxFit.contain,
    this.color,
  })  : imageUrl = null,
        imagePath = null,
        svgUrl = null,
        icon = null,
        useDiskCache = true;

  ImageView.networkSvg(
    this.svgUrl, {
    this.width,
    this.height,
    this.fit = BoxFit.contain,
    this.size,
    this.color,
    this.useDiskCache = true,
  })  : imageUrl = null,
        imagePath = null,
        icon = null,
        svgPath = null;

  ImageView.icon(
    this.icon, {
    this.size,
    this.color,
  })  : imageUrl = null,
        imagePath = null,
        svgPath = null,
        svgUrl = null,
        width = null,
        height = null,
        fit = null,
        useDiskCache = null;

  /// 本地图片路径
  final String imagePath;

  /// 图片url
  final String imageUrl;

  /// 本地svg路径
  final String svgPath;

  /// svg的url
  final String svgUrl;

  /// 宽度 如果同时设置了[width], [height]和[size], 那么优先[size]
  final double width;

  /// 高度 如果同时设置了[width], [height]和[size], 那么优先[size]
  final double height;

  /// 适应模式
  final BoxFit fit;

  /// 颜色
  final Color color;

  /// 是否使用硬盘缓存
  final bool useDiskCache;

  /// icon
  final IconData icon;

  /// 大小, 如果同时设置了[width], [height]和[size], 那么优先[size]
  final double size;

  @override
  Widget build(BuildContext context) {
    if (imagePath != null) {
      return Image.asset(
        imagePath,
        width: size ?? width,
        height: size ?? height,
        fit: fit,
        color: color,
      );
    } else if (imageUrl != null) {
      return Image(
        image: AdvancedNetworkImage(imageUrl, useDiskCache: useDiskCache),
        width: size ?? width,
        height: size ?? height,
        fit: fit,
        color: color,
      );
    } else if (svgPath != null) {
      return SvgPicture.asset(
        svgPath,
        width: size ?? width,
        height: size ?? height,
        fit: fit,
        color: color,
      );
    } else if (svgUrl != null) {
      return SvgPicture.network(
        svgUrl,
        width: size ?? width,
        height: size ?? height,
        fit: fit,
        color: color,
      );
    } else if (icon != null) {
      return Icon(icon, size: size, color: color);
    } else {
      return ErrorWidget('imagePath, imageUrl, svgPath不能同时为空');
    }
  }
}
