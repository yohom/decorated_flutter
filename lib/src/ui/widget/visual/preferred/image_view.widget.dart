import 'dart:io';
import 'dart:typed_data';

import 'package:cached_network_image/cached_network_image.dart';
import 'package:decorated_flutter/src/annotation/annotation.export.dart';
import 'package:decorated_flutter/src/extension/extension.export.dart';
import 'package:dio/dio.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:flutter_cache_manager/flutter_cache_manager.dart';
import 'package:flutter_svg/svg.dart';

typedef LoadingProgress = void Function(double progress, List<int> data);

class CryptoOption {
  /// 解密
  final Future<Uint8List> Function(Uint8List encrypted) decrypt;

  /// 是否作用在网络图片
  final bool enableNetworkImage;

  /// 是否作用在asset图片
  @wip
  final bool enableAssetImage;

  /// 是否作用在内存图片
  @wip
  final bool enableMemoryImage;

  CryptoOption({
    required this.decrypt,
    this.enableNetworkImage = true,
    this.enableAssetImage = true,
    this.enableMemoryImage = true,
  });

  @override
  String toString() {
    return 'CryptoOption{decrypt: $decrypt, enableNetworkImage: $enableNetworkImage, enableAssetImage: $enableAssetImage, enableMemoryImage: $enableMemoryImage}';
  }
}

class ImageView extends StatelessWidget {
  /// 加解密选项
  static CryptoOption? _cryptoOption;
  static Widget? globalErrorWidget;
  static Widget? globalPlaceholder;

  static set cryptoOption(CryptoOption? value) {
    _cryptoOption = value;
  }

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
    this.fit = BoxFit.cover,
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
    this.borderRadius,
    this.shape,
    this.colorBlendMode,
    this.errorWidget,
    this.placeholder,
  })  : imagePath = imageUri.isUrl ? null : imageUri,
        imageUrl = imageUri.isUrl ? imageUri : null,
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
    this.borderRadius,
    this.shape,
    this.colorBlendMode,
    this.errorWidget,
    this.placeholder,
  })  : imageUrl = null,
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
    this.errorWidget,
    this.placeholder,
    this.padding,
    this.margin,
    this.darkImagePath,
    this.autoDarkMode = false,
    this.autoApplyKey = true,
    this.decoration,
    this.foregroundDecoration,
    this.clipBehavior = Clip.hardEdge,
    this.aspectRatio,
    this.borderRadius,
    this.shape,
    this.colorBlendMode,
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
  final Widget? errorWidget;

  /// 占位图
  final Widget? placeholder;

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

  /// 如果不为空, 则使用AspectRatio包裹
  final double? aspectRatio;

  /// 圆角 是BoxDecoration的shortcut
  final BorderRadius? borderRadius;

  /// 圆形还是方形
  final BoxShape? shape;

  /// 颜色混合模式
  final BlendMode? colorBlendMode;

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
    final _placeholder = placeholder ?? globalPlaceholder;
    final _errorWidget = errorWidget ?? globalErrorWidget;

    Widget result;
    // 本地图片
    if (imagePath != null) {
      String _imagePath = imagePath!;
      if (darkImagePath != null) {
        _imagePath = isDarkMode ? darkImagePath! : imagePath!;
      }
      if (_imagePath.endsWith('.svg')) {
        result = SvgPicture.asset(
          _imagePath,
          key: autoApplyKey ? Key(_imagePath) : null,
          width: width,
          height: height,
          fit: fit ?? BoxFit.contain,
          color: _color,
          placeholderBuilder: _placeholder != null ? (_) => _placeholder : null,
        );
      } else if (_imagePath.startsWith('/')) {
        result = Image.file(
          File(_imagePath),
          key: autoApplyKey ? Key(_imagePath) : null,
          width: width,
          height: height,
          fit: fit,
          color: _color,
          gaplessPlayback: true,
          colorBlendMode: colorBlendMode,
          cacheWidth: _cacheWidth,
          cacheHeight: _cacheHeight,
          errorBuilder:
              _errorWidget != null ? (_, __, ___) => _errorWidget : null,
        );
      } else {
        result = Image.asset(
          _imagePath,
          key: autoApplyKey ? Key(_imagePath) : null,
          width: width,
          height: height,
          fit: fit,
          color: _color,
          gaplessPlayback: true,
          colorBlendMode: colorBlendMode,
          cacheWidth: _cacheWidth,
          cacheHeight: _cacheHeight,
          errorBuilder:
              _errorWidget != null ? (_, __, ___) => _errorWidget : null,
        );
      }
    }
    // 网络图片
    else if (imageUrl != null) {
      if (imageUrl!.endsWith('.svg')) {
        result = SvgPicture.network(
          imageUrl!,
          key: autoApplyKey ? Key(imageUrl!) : null,
          width: width,
          height: height,
          fit: fit ?? BoxFit.contain,
          color: _color,
          placeholderBuilder: _placeholder != null ? (_) => _placeholder : null,
        );
      } else {
        if (ImageView._cryptoOption?.enableNetworkImage == true) {
          result = _encryptedImage(context, imageUrl!);
        } else {
          result = CachedNetworkImage(
            imageUrl: imageUrl!,
            key: autoApplyKey ? Key(imageUrl!) : null,
            width: width,
            height: height,
            fit: fit,
            color: _color,
            placeholder: _placeholder != null ? (_, __) => _placeholder : null,
            errorWidget:
                _errorWidget != null ? (_, __, ___) => _errorWidget : null,
            memCacheWidth: _cacheWidth,
            memCacheHeight: _cacheHeight,
          );
        }
      }
    } else {
      // 如果图片地址为null的话, 那就不显示
      result = const SizedBox.shrink();
    }

    if (size != null || width != null || height != null) {
      result = SizedBox(width: _width, height: _height, child: result);
    }

    if (padding != null ||
        margin != null ||
        decoration != null ||
        foregroundDecoration != null ||
        borderRadius != null ||
        shape != null) {
      Decoration? _decoration = decoration;
      if (_decoration == null && (borderRadius != null || shape != null)) {
        _decoration = BoxDecoration(
          borderRadius: borderRadius,
          shape: shape ?? BoxShape.rectangle,
        );
      }

      result = Container(
        clipBehavior: _decoration != null ? Clip.hardEdge : Clip.none,
        padding: padding,
        margin: margin,
        foregroundDecoration: foregroundDecoration,
        decoration: _decoration,
        child: result,
      );
    }

    if (aspectRatio != null) {
      result = AspectRatio(aspectRatio: aspectRatio!, child: result);
    }

    return result;
  }

  Widget _encryptedImage(BuildContext context, String imageUri) {
    final isDarkMode = context.isDarkMode;
    Color? _color = color;
    if (autoDarkMode) {
      _color = isDarkMode ? Colors.white : null;
    }
    final _width = size ?? width;
    final _height = size ?? height;
    final _cacheWidth = cacheSize ?? cacheWidth;
    final _cacheHeight = cacheSize ?? cacheHeight;

    Future<Uint8List> imageFuture;
    if (kIsWeb) {
      // web端就先不缓存了
      imageFuture = Dio()
          .get(imageUri, options: Options(responseType: ResponseType.bytes))
          .then((value) => value.data);
    } else {
      imageFuture = DefaultCacheManager()
          .getSingleFile(imageUri)
          .then((value) => value.readAsBytes());
    }

    return FutureBuilder<Uint8List>(
      future: imageFuture.then(ImageView._cryptoOption!.decrypt),
      builder: (_, snapshot) {
        if (snapshot.hasData) {
          return Image.memory(
            snapshot.requireData,
            key: autoApplyKey ? Key(imageUri) : null,
            width: _width,
            height: _height,
            cacheWidth: _cacheWidth,
            cacheHeight: _cacheHeight,
            color: _color,
            fit: fit,
            gaplessPlayback: true,
          );
        } else if (snapshot.hasError) {
          return errorWidget ?? globalErrorWidget ?? const SizedBox.shrink();
        } else {
          return placeholder ?? globalPlaceholder ?? const SizedBox.shrink();
        }
      },
    );
  }
}

extension on String {
  bool get isUrl {
    return startsWith('http') || startsWith('blob:http');
  }
}
