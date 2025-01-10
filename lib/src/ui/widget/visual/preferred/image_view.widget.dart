import 'dart:io';

import 'package:cached_network_image/cached_network_image.dart';
import 'package:decorated_flutter/src/extension/extension.export.dart';
import 'package:decorated_flutter/src/ui/ui.export.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:flutter_svg/svg.dart';

import '../../../../utils/utils.export.dart';

typedef LoadingProgress = void Function(double progress, List<int> data);

class ImageViewProvider extends ImageProvider {
  ImageViewProvider(
    String uri, {
    int? maxHeight,
    int? maxWidth,
  }) : _delegate = uri.startsWith('http')
            ? CachedNetworkImageProvider(
                uri,
                maxHeight: maxHeight,
                maxWidth: maxHeight,
              )
            : (uri.startsWith('/') || uri.startsWith('file://'))
                ? FileImage(File(uri)) as ImageProvider
                : AssetImage(uri);

  final ImageProvider _delegate;

  @override
  Future<Object> obtainKey(ImageConfiguration configuration) {
    return _delegate.obtainKey(configuration);
  }

  @override
  @protected
  ImageStream createStream(ImageConfiguration configuration) {
    return _delegate.createStream(configuration);
  }

  @override
  Future<ImageCacheStatus?> obtainCacheStatus({
    required ImageConfiguration configuration,
    ImageErrorListener? handleError,
  }) {
    return _delegate.obtainCacheStatus(configuration: configuration);
  }

  @override
  ImageStreamCompleter loadBuffer(Object key, DecoderBufferCallback decode) {
    return _delegate.loadBuffer(key, decode);
  }
}

class ImageView extends StatelessWidget {
  static Widget? globalErrorWidget;
  static Widget? globalPlaceholder;
  static bool logEnable = false;
  static bool suppressError = false;
  static Map<String, String> headers = {};

  /// 根据图片uri自动判断是使用本地加载还是远程加载
  ImageView(
    String imageUri, {
    super.key,
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
    this.scale,
    this.alignment = Alignment.center,
  })  : imagePath = imageUri.isUrl ? null : imageUri,
        imageUrl = imageUri.isUrl ? imageUri : null,
        assert(
          (darkImagePath != null && autoDarkMode == false) ||
              darkImagePath == null,
          '不能同时设置darkImagePath和autoDarkMode',
        );

  /// 跟默认构造器的区别是icon构造器默认是BoxFit.contain
  ImageView.icon(
    String imageUri, {
    super.key,
    this.width,
    this.height,
    this.size,
    this.cacheWidth,
    this.cacheHeight,
    this.cacheSize,
    this.fit = BoxFit.contain,
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
    this.scale,
    this.alignment = Alignment.center,
  })  : imagePath = imageUri.isUrl ? null : imageUri,
        imageUrl = imageUri.isUrl ? imageUri : null,
        assert(
          (darkImagePath != null && autoDarkMode == false) ||
              darkImagePath == null,
          '不能同时设置darkImagePath和autoDarkMode',
        );

  const ImageView.local(
    this.imagePath, {
    super.key,
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
    this.scale,
    this.alignment = Alignment.center,
  })  : imageUrl = null,
        assert(
          (darkImagePath != null && autoDarkMode == false) ||
              darkImagePath == null,
          '不能同时设置darkImagePath和autoDarkMode',
        );

  const ImageView.remote(
    this.imageUrl, {
    super.key,
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
    this.scale,
    this.alignment = Alignment.center,
  })  : imagePath = null,
        assert(
          (darkImagePath != null && autoDarkMode == false) ||
              darkImagePath == null,
          '不能同时设置darkImagePath和autoDarkMode',
        );

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

  /// 缩放
  final double? scale;

  /// 对齐
  final Alignment alignment;

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
          alignment: alignment,
          fit: fit ?? BoxFit.contain,
          color: _color,
          placeholderBuilder: _placeholder != null ? (_) => _placeholder : null,
        );

        if (logEnable) L.d('使用SvgPicture.asset: $_imagePath');
      } else if (_imagePath.startsWith('/') ||
          _imagePath.startsWith('file://')) {
        result = kIsWeb // web端的文件路径使用network加载
            ? Image.network(
                _imagePath,
                key: autoApplyKey ? Key(_imagePath) : null,
                width: width,
                height: height,
                fit: fit,
                color: _color,
                gaplessPlayback: true,
                scale: scale ?? 1,
                colorBlendMode: colorBlendMode,
                cacheWidth: _cacheWidth,
                cacheHeight: _cacheHeight,
                errorBuilder: _errorBuilder,
                alignment: alignment,
              )
            : Image.file(
                File(_imagePath),
                key: autoApplyKey ? Key(_imagePath) : null,
                width: width,
                height: height,
                fit: fit,
                color: _color,
                gaplessPlayback: true,
                scale: scale ?? 1,
                colorBlendMode: colorBlendMode,
                cacheWidth: _cacheWidth,
                cacheHeight: _cacheHeight,
                errorBuilder: _errorBuilder,
                alignment: alignment,
              );
        if (logEnable) L.d('使用Image.file: $_imagePath');
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
          scale: scale,
          cacheWidth: _cacheWidth,
          cacheHeight: _cacheHeight,
          errorBuilder: _errorBuilder,
          alignment: alignment,
        );
        if (logEnable) L.d('使用Image.asset: $_imagePath');
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
          headers: headers,
          color: _color,
          placeholderBuilder: _placeholder != null ? (_) => _placeholder : null,
          alignment: alignment,
        );
        if (logEnable) L.d('使用SvgPicture.network: $imageUrl');
      } else {
        result = kIsWeb
            ? Image.network(
                imageUrl!,
                key: autoApplyKey ? Key(imageUrl!) : null,
                width: width,
                height: height,
                fit: fit,
                color: _color,
                errorBuilder: _errorBuilder,
                gaplessPlayback: true,
                scale: scale ?? 1,
                headers: headers,
                cacheHeight: _cacheWidth,
                cacheWidth: _cacheHeight,
                colorBlendMode: colorBlendMode,
                alignment: alignment,
                loadingBuilder: placeholder != null
                    ? (_, child, loadingProgress) {
                        if (loadingProgress == null) return child;
                        return placeholder!;
                      }
                    : null,
              )
            : CachedNetworkImage(
                imageUrl: imageUrl!,
                key: autoApplyKey ? Key(imageUrl!) : null,
                width: width,
                height: height,
                fit: fit,
                color: _color,
                httpHeaders: headers,
                placeholder:
                    _placeholder != null ? (_, __) => _placeholder : null,
                errorWidget: _errorBuilder,
                memCacheWidth: _cacheWidth,
                memCacheHeight: _cacheHeight,
                alignment: alignment,
              );
        if (logEnable) L.d('使用CachedNetworkImage: $imageUrl');
      }
    } else {
      // 如果图片地址为null的话, 那就不显示
      result = SizedBox(width: _width, height: _height);
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

  // Widget _encryptedImage(BuildContext context, String imageUri) {
  //   final isDarkMode = context.isDarkMode;
  //   Color? _color = color;
  //   if (autoDarkMode) {
  //     _color = isDarkMode ? Colors.white : null;
  //   }
  //   final _width = size ?? width;
  //   final _height = size ?? height;
  //   final _cacheWidth = cacheSize ?? cacheWidth;
  //   final _cacheHeight = cacheSize ?? cacheHeight;
  //
  //   Future<Uint8List> imageFuture;
  //   if (kIsWeb) {
  //     // web端就先不缓存了
  //     imageFuture = Dio()
  //         .get(imageUri, options: Options(responseType: ResponseType.bytes))
  //         .then((value) => value.data);
  //   } else {
  //     imageFuture = DefaultCacheManager()
  //         .getSingleFile(imageUri)
  //         .then((value) => value.readAsBytes());
  //   }
  //
  //   return FutureBuilder<Uint8List>(
  //     future: imageFuture.then(ImageView._cryptoOption!.decrypt),
  //     builder: (_, snapshot) {
  //       if (snapshot.hasData) {
  //         return Image.memory(
  //           snapshot.requireData,
  //           key: autoApplyKey ? Key(imageUri) : null,
  //           width: _width,
  //           height: _height,
  //           cacheWidth: _cacheWidth,
  //           cacheHeight: _cacheHeight,
  //           color: _color,
  //           fit: fit,
  //           gaplessPlayback: true,
  //         );
  //       } else if (snapshot.hasError) {
  //         return errorWidget ?? globalErrorWidget ?? const SizedBox.shrink();
  //       } else {
  //         return placeholder ?? globalPlaceholder ?? const SizedBox.shrink();
  //       }
  //     },
  //   );
  // }

  Widget _errorBuilder(
    BuildContext context,
    dynamic error,
    dynamic stackTrace,
  ) {
    final _errorWidget = errorWidget ?? globalErrorWidget;
    if (!suppressError) L.e('显示ImageView发生错误: $error, stacktrace: $stackTrace');
    return _errorWidget ?? (kReleaseMode ? NIL : ErrorWidget(error));
  }
}

extension on String {
  bool get isUrl {
    return startsWith('http') || startsWith('blob:http');
  }
}
