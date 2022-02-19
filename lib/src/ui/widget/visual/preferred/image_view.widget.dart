import 'dart:io';

import 'package:cached_network_image/cached_network_image.dart';
import 'package:decorated_flutter/src/extension/extension.export.dart';
import 'package:flutter/material.dart';
import 'package:flutter_svg/svg.dart';

typedef LoadingProgress = void Function(double progress, List<int> data);

// TODO 透明图片颜色 https://api.flutter.dev/flutter/widgets/Opacity-class.html#transparent-image
class ImageView extends StatelessWidget {
  /// 根据图片uri自动判断是使用本地加载还是远程加载
  ImageView(
    String imageUri, {
    Key? key,
    this.width,
    this.height,
    this.size,
    this.cacheWidth,
    this.cacheHeight,
    this.cacheSize,
    this.fit,
    this.color,
    this.padding,
    this.margin,
    this.darkImagePath,
    this.autoDarkMode = false,
    this.autoApplyKey = true,
    this.decoration,
    this.foregroundDecoration,
    this.clipBehavior = Clip.hardEdge,
    this.aspectRatio,
  })  : imagePath = imageUri.startsWith('http') ? null : imageUri,
        imageUrl = imageUri.startsWith('http') ? imageUri : null,
        errorWidget = const SizedBox.shrink(),
        placeholder = const SizedBox.shrink(),
        assert(
          (darkImagePath != null && autoDarkMode == false) ||
              darkImagePath == null,
          '不能同时设置darkImagePath和autoDarkMode',
        ),
        super(key: key);

  const ImageView.local(
    this.imagePath, {
    Key? key,
    this.width,
    this.height,
    this.size,
    this.cacheWidth,
    this.cacheHeight,
    this.cacheSize,
    this.fit,
    this.color,
    this.padding,
    this.margin,
    this.darkImagePath,
    this.autoDarkMode = false,
    this.autoApplyKey = true,
    this.decoration,
    this.foregroundDecoration,
    this.clipBehavior = Clip.hardEdge,
    this.aspectRatio,
  })  : imageUrl = null,
        errorWidget = const SizedBox.shrink(),
        placeholder = const SizedBox.shrink(),
        assert(
          (darkImagePath != null && autoDarkMode == false) ||
              darkImagePath == null,
          '不能同时设置darkImagePath和autoDarkMode',
        ),
        super(key: key);

  const ImageView.remote(
    this.imageUrl, {
    Key? key,
    this.width,
    this.height,
    this.size,
    this.cacheWidth,
    this.cacheHeight,
    this.cacheSize,
    this.fit,
    this.color,
    this.errorWidget = const SizedBox.shrink(),
    this.placeholder = const SizedBox.shrink(),
    this.padding,
    this.margin,
    this.darkImagePath,
    this.autoDarkMode = false,
    this.autoApplyKey = true,
    this.decoration,
    this.foregroundDecoration,
    this.clipBehavior = Clip.hardEdge,
    this.aspectRatio,
  })  : imagePath = null,
        assert(
          (darkImagePath != null && autoDarkMode == false) ||
              darkImagePath == null,
          '不能同时设置darkImagePath和autoDarkMode',
        ),
        super(key: key);

  /// 本地图片路径
  final String? imagePath;

  /// 图片url
  final String? imageUrl;

  /// 宽高 如果同时设置了[width], [height]和[size], 那么优先[size]
  final double? width, height, size;

  /// 缓存宽高
  ///
  /// 如果设置了, 会resize原始图片再显示, 可以优化过大的图片显示
  final int? cacheWidth, cacheHeight, cacheSize;

  /// 适应模式
  final BoxFit? fit;

  /// 颜色
  final Color? color;

  /// 备用的asset image路径
  final Widget errorWidget;

  /// 占位图
  final Widget placeholder;

  /// 边距
  final EdgeInsets? padding, margin;

  /// 暗黑模式路径模式
  ///
  /// 用于自动化实现暗黑模式, 如果设置了就会忽略[autoDarkMode]
  final String? darkImagePath;

  /// 是否自动化暗黑模式
  ///
  /// 实现方式为在暗黑模式下设置颜色为白色
  final bool autoDarkMode;

  /// 是否自动设置图片路径为key
  ///
  /// 默认为true, 这个是为了测试时方便通过key来寻找widget. 有的时候希望内部的Image保持一个实例,
  /// 不因为图片切换而改变(造成闪烁), 此时可以设置[autoApplyKey]为false.
  final bool autoApplyKey;

  /// 背景
  final BoxDecoration? decoration;

  /// 前景
  final BoxDecoration? foregroundDecoration;

  /// 剪裁行为
  final Clip? clipBehavior;

  /// 如果部位空, 则使用AspectRatio包裹
  final double? aspectRatio;

  @override
  Widget build(BuildContext context) {
    final isDarkMode = context.isDarkMode;
    Color? _color = color;
    if (autoDarkMode) {
      _color = isDarkMode ? Colors.white : null;
    }
    final _width = size ?? width;
    final _height = size ?? height;
    final _cacheWidth = cacheSize ?? cacheWidth;
    final _cacheHeight = cacheSize ?? cacheHeight;

    Widget result;
    if (imagePath != null) {
      String _imagePath = imagePath!;
      if (darkImagePath != null) {
        _imagePath = isDarkMode ? darkImagePath! : imagePath!;
      }
      if (_imagePath.endsWith('.svg')) {
        result = SvgPicture.asset(
          _imagePath,
          key: autoApplyKey ? Key(_imagePath) : null,
          width: _width,
          height: _height,
          fit: fit ?? BoxFit.contain,
          color: _color,
          placeholderBuilder: (_) => placeholder,
        );
      } else if (_imagePath.startsWith('/')) {
        result = Image.file(
          File(_imagePath),
          key: autoApplyKey ? Key(_imagePath) : null,
          width: _width,
          height: _height,
          fit: fit,
          color: _color,
          gaplessPlayback: true,
          cacheWidth: _cacheWidth,
          cacheHeight: _cacheHeight,
        );
      } else {
        result = Image.asset(
          _imagePath,
          key: autoApplyKey ? Key(_imagePath) : null,
          width: _width,
          height: _height,
          fit: fit,
          color: _color,
          gaplessPlayback: true,
          cacheWidth: _cacheWidth,
          cacheHeight: _cacheHeight,
        );
      }
    } else if (imageUrl != null) {
      if (imageUrl!.endsWith('.svg')) {
        result = SvgPicture.network(
          imageUrl!,
          key: autoApplyKey ? Key(imageUrl!) : null,
          width: _width,
          height: _height,
          fit: fit ?? BoxFit.contain,
          color: _color,
          placeholderBuilder: (_) => placeholder,
        );
      } else {
        result = CachedNetworkImage(
          imageUrl: imageUrl!,
          key: autoApplyKey ? Key(imageUrl!) : null,
          width: _width,
          height: _height,
          fit: fit,
          color: _color,
          placeholder: (_, __) => placeholder,
          errorWidget: (_, __, ___) => errorWidget,
          memCacheWidth: _cacheWidth,
          memCacheHeight: _cacheHeight,
        );
      }
    } else {
      // 如果图片地址为null的话, 那就不显示
      result = const SizedBox.shrink();
    }

    if (size != null || width != null || height != null) {
      result = SizedBox(
        width: _width,
        height: _height,
        child: result,
      );
    }

    if (padding != null ||
        margin != null ||
        decoration != null ||
        foregroundDecoration != null) {
      result = Container(
        clipBehavior: decoration != null ? Clip.hardEdge : Clip.none,
        padding: padding,
        margin: margin,
        foregroundDecoration: foregroundDecoration,
        decoration: decoration,
        child: result,
      );
    }

    if (aspectRatio != null) {
      result = AspectRatio(aspectRatio: aspectRatio!, child: result);
    }

    return result;
  }
}
