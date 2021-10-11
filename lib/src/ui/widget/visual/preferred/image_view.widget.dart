import 'package:cached_network_image/cached_network_image.dart';
import 'package:decorated_flutter/src/extension/extension.export.dart';
import 'package:flutter/material.dart';
import 'package:flutter_svg/svg.dart';

typedef LoadingProgress = void Function(double progress, List<int> data);

// TODO 透明图片颜色 https://api.flutter.dev/flutter/widgets/Opacity-class.html#transparent-image
class ImageView extends StatelessWidget {
  const ImageView.asset(
    this.imagePath, {
    Key? key,
    this.width,
    this.height,
    this.size,
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
  })  : imageUrl = null,
        errorWidget = const SizedBox.shrink(),
        placeholder = const SizedBox.shrink(),
        assert(
          (darkImagePath != null && autoDarkMode == false) ||
              darkImagePath == null,
          '不能同时设置darkImagePath和autoDarkMode',
        ),
        super(key: key);

  const ImageView.network(
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
    this.darkImagePath,
    this.autoDarkMode = false,
    this.autoApplyKey = true,
    this.decoration,
    this.foregroundDecoration,
    this.clipBehavior = Clip.hardEdge,
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

  @override
  Widget build(BuildContext context) {
    final isDarkMode = context.isDarkMode;
    Color? _color = color;
    if (autoDarkMode) {
      _color = isDarkMode ? Colors.white : null;
    }
    Widget result;
    if (imagePath != null) {
      String _imagePath = imagePath!;
      if (darkImagePath != null) {
        _imagePath = isDarkMode ? darkImagePath! : imagePath!;
      }
      if (_imagePath.endsWith('svg')) {
        result = SvgPicture.asset(
          _imagePath,
          key: autoApplyKey ? Key(_imagePath) : null,
          width: size ?? width,
          height: size ?? height,
          fit: fit ?? BoxFit.contain,
          color: _color,
          placeholderBuilder: (_) => placeholder,
        );
      } else {
        result = Image.asset(
          _imagePath,
          key: autoApplyKey ? Key(_imagePath) : null,
          width: size ?? width,
          height: size ?? height,
          fit: fit,
          color: _color,
          gaplessPlayback: true,
        );
      }
    } else if (imageUrl != null) {
      if (imageUrl!.endsWith('svg')) {
        result = SvgPicture.network(
          imageUrl!,
          key: autoApplyKey ? Key(imageUrl!) : null,
          width: size ?? width,
          height: size ?? height,
          fit: fit ?? BoxFit.contain,
          color: _color,
          placeholderBuilder: (_) => placeholder,
        );
      } else {
        result = CachedNetworkImage(
          imageUrl: imageUrl!,
          key: autoApplyKey ? Key(imageUrl!) : null,
          width: size ?? width,
          height: size ?? height,
          fit: fit,
          color: _color,
          placeholder: (_, __) => placeholder,
          errorWidget: (_, __, ___) => errorWidget,
        );
      }
    } else {
      // 如果图片地址为null的话, 那就不显示
      result = const SizedBox.shrink();
    }

    if (size != null || width != null || height != null) {
      result = SizedBox(
        width: size ?? width,
        height: size ?? height,
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

    return result;
  }
}
