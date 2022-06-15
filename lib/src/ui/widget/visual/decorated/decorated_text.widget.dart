import 'package:decorated_flutter/src/model/model.export.dart';
import 'package:decorated_flutter/src/utils/utils.export.dart';
import 'package:flutter/material.dart';

class DecoratedText extends StatelessWidget {
  const DecoratedText(
    this._data, {
    Key? key,
    this.padding,
    this.margin,
    this.decoration,
    this.foregroundDecoration,
    this.style,
    this.strutStyle = const StrutStyle(),
    this.safeArea,
    this.onPressed,
    this.maxLines,
    this.textAlign,
    this.overflow, // 默认TextOverflow.ellipsis时, 会只有一行文字+省略号
    this.constraints,
    this.expanded = false,
    this.visible,
    this.width,
    this.height,
    this.center,
    this.transform,
    this.sliver,
    this.leftWidget,
    this.rightWidget,
    this.softWrap = true,
    this.material,
    this.mainAxisAlignment,
    this.crossAxisAlignment,
    this.textBaseline,
    this.behavior,
    this.textExpanded = false,
    this.textFlexible = false,
    this.widgetPadding,
    this.alignment,
  })  : _stream = null,
        initialData = null,
        super(key: key);

  const DecoratedText.reactive(
    this._stream, {
    Key? key,
    this.initialData,
    this.padding,
    this.margin,
    this.decoration,
    this.foregroundDecoration,
    this.style,
    this.strutStyle = const StrutStyle(),
    this.safeArea,
    this.onPressed,
    this.maxLines,
    this.textAlign,
    this.overflow, // 默认TextOverflow.ellipsis时, 会只有一行文字+省略号
    this.constraints,
    this.expanded = false,
    this.visible,
    this.width,
    this.height,
    this.center,
    this.transform,
    this.sliver,
    this.leftWidget,
    this.rightWidget,
    this.softWrap = true,
    this.material,
    this.mainAxisAlignment,
    this.crossAxisAlignment,
    this.textBaseline,
    this.behavior,
    this.textExpanded = false,
    this.textFlexible = false,
    this.widgetPadding,
    this.alignment,
  })  : _data = null,
        super(key: key);

  final Stream<String>? _stream;
  final String? initialData;

  /// 内边距
  final EdgeInsetsGeometry? padding;

  /// 外边距
  final EdgeInsetsGeometry? margin;

  /// 作用于Container的decoration
  final BoxDecoration? decoration;
  final BoxDecoration? foregroundDecoration;
  final TextStyle? style;
  final StrutStyle strutStyle;
  final String? _data;
  final SafeAreaConfig? safeArea;
  final ContextCallback? onPressed;
  final int? maxLines;
  final TextAlign? textAlign;
  final TextOverflow? overflow;
  final BoxConstraints? constraints;
  final bool expanded;
  final double? width;
  final double? height;
  final bool? visible;
  final bool? center;
  final bool? sliver;
  final Matrix4? transform;
  final Widget? leftWidget;
  final Widget? rightWidget;
  final bool softWrap;
  final bool? material;
  final MainAxisAlignment? mainAxisAlignment;
  final CrossAxisAlignment? crossAxisAlignment;
  final TextBaseline? textBaseline;
  final HitTestBehavior? behavior;
  final bool textExpanded;
  final bool textFlexible;
  final double? widgetPadding;
  final Alignment? alignment;

  @override
  Widget build(BuildContext context) {
    final _overflow =
        maxLines == 1 ? (overflow ?? TextOverflow.ellipsis) : overflow;
    Widget result = _data != null
        ? Text(
            _data!,
            maxLines: maxLines,
            style: style ?? DefaultTextStyle.of(context).style,
            strutStyle: strutStyle,
            textAlign: textAlign,
            overflow: _overflow,
            softWrap: softWrap,
          )
        : StreamBuilder<String>(
            stream: _stream!,
            initialData: initialData,
            builder: (context, snapshot) {
              return Text(
                snapshot.data ?? '',
                maxLines: maxLines,
                style: style ?? DefaultTextStyle.of(context).style,
                strutStyle: strutStyle,
                textAlign: textAlign,
                overflow: _overflow,
                softWrap: softWrap,
              );
            },
          );

    if (rightWidget != null || leftWidget != null) {
      result = Row(
        mainAxisAlignment: mainAxisAlignment ?? MainAxisAlignment.center,
        crossAxisAlignment: crossAxisAlignment ?? CrossAxisAlignment.center,
        textBaseline: textBaseline,
        children: [
          if (leftWidget != null) leftWidget!,
          if (widgetPadding != null && leftWidget != null)
            SizedBox(width: widgetPadding!),
          if (textExpanded)
            Expanded(child: result)
          else if (textFlexible)
            Flexible(child: result)
          else
            result,
          if (widgetPadding != null && rightWidget != null)
            SizedBox(width: widgetPadding!),
          if (rightWidget != null) rightWidget!,
        ],
      );
    }

    if (width != null ||
        height != null ||
        decoration != null ||
        foregroundDecoration != null ||
        margin != null ||
        padding != null ||
        constraints != null ||
        transform != null ||
        alignment != null ||
        center != null) {
      result = Container(
        width: width,
        height: height,
        margin: margin,
        padding: padding,
        decoration: decoration,
        foregroundDecoration: foregroundDecoration,
        constraints: constraints,
        transform: transform,
        alignment: alignment ?? (center == true ? Alignment.center : null),
        child: result,
      );
    }

    if (safeArea != null) {
      result = SafeArea(
        top: safeArea?.top ?? true,
        bottom: safeArea?.bottom ?? true,
        left: safeArea?.left ?? true,
        right: safeArea?.right ?? true,
        child: result,
      );
    }

    if (onPressed != null) {
      result = GestureDetector(
        behavior: behavior ?? HitTestBehavior.opaque,
        onTap: () => onPressed!(context),
        child: result,
      );
    }

    if (visible != null) {
      result = Visibility(visible: visible!, child: result);
    }

    if (material == true) {
      result = Material(color: Colors.transparent, child: result);
    }

    if (expanded == true) {
      result = Expanded(child: result);
    }

    if (sliver == true) {
      result = SliverToBoxAdapter(child: result);
    }

    return result;
  }
}
