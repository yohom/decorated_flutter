import 'package:flutter/material.dart';
import 'package:flutter_advanced_networkimage/provider.dart';
import 'package:flutter_svg/flutter_svg.dart';

class ImageView extends StatelessWidget {
  ImageView.assetImage(
    this.imagePath, {
    this.width,
    this.height,
    this.fit = BoxFit.contain,
    this.color,
  })  : imageUrl = null,
        svgPath = null,
        svgUrl = null,
        useDiskCache = true;

  ImageView.networkImage(
    this.imageUrl, {
    this.width,
    this.height,
    this.fit = BoxFit.contain,
    this.color,
    this.useDiskCache = true,
  })  : imagePath = null,
        svgUrl = null,
        svgPath = null;

  ImageView.assetSvg(
    this.svgPath, {
    this.width,
    this.height,
    this.fit = BoxFit.contain,
    this.color,
  })  : imageUrl = null,
        imagePath = null,
        svgUrl = null,
        useDiskCache = true;

  ImageView.networkSvg(
    this.svgUrl, {
    this.width,
    this.height,
    this.fit = BoxFit.contain,
    this.color,
  })  : imageUrl = null,
        imagePath = null,
        svgPath = null,
        useDiskCache = true;

  final String imagePath;
  final String imageUrl;
  final String svgPath;
  final String svgUrl;
  final double width;
  final double height;
  final BoxFit fit;
  final Color color;
  final bool useDiskCache;

  @override
  Widget build(BuildContext context) {
    if (imagePath != null) {
      return Image.asset(
        imagePath,
        width: width,
        height: height,
        fit: fit,
        color: color,
      );
    } else if (imageUrl != null) {
      return Image(
        image: AdvancedNetworkImage(imageUrl, useDiskCache: useDiskCache),
        width: width,
        height: height,
        fit: fit,
        color: color,
      );
    } else if (svgPath != null) {
      return SvgPicture.asset(
        svgPath,
        width: width,
        height: height,
        fit: fit,
        color: color,
      );
    } else if (svgUrl != null) {
      return SvgPicture.network(
        svgUrl,
        width: width,
        height: height,
        fit: fit,
        color: color,
      );
    } else {
      return ErrorWidget('imagePath, imageUrl, svgPath不能同时为空');
    }
  }
}
