import 'package:decorated_flutter/src/model/model.export.dart';
import 'package:decorated_flutter/src/utils/utils.export.dart';
import 'package:flutter/material.dart';

class DecoratedText extends StatelessWidget {
  const DecoratedText(
    this._data, {
    super.key,
    this.padding,
    this.margin,
    this.decoration,
    this.foregroundDecoration,
    this.style,
    this.strutStyle = const StrutStyle(),
    this.safeArea,
    this.onPressed,
    this.onLongPressed,
    this.maxLines,
    this.textAlign,
    this.overflow, // 默认TextOverflow.ellipsis时, 会只有一行文字+省略号
    this.constraints,
    this.expanded = false,
    this.flexible = false,
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
    this.mainAxisSize = MainAxisSize.max,
    this.mainAxisAlignment,
    this.crossAxisAlignment,
    this.textBaseline,
    this.behavior,
    this.textExpanded = false,
    this.textFlexible = false,
    this.widgetPadding,
    this.isSelectable = false,
    this.alignment,
    this.paragraphPadding,
    this.scrollable = false,
    this.scrollDirection,
    this.scrollPadding,
    this.cursor,
  })  : _stream = null,
        initialData = null;

  const DecoratedText.reactive(
    this._stream, {
    super.key,
    this.initialData,
    this.padding,
    this.margin,
    this.decoration,
    this.foregroundDecoration,
    this.style,
    this.strutStyle = const StrutStyle(),
    this.safeArea,
    this.onPressed,
    this.onLongPressed,
    this.maxLines,
    this.textAlign,
    this.overflow, // 默认TextOverflow.ellipsis时, 会只有一行文字+省略号
    this.constraints,
    this.expanded = false,
    this.flexible = false,
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
    this.mainAxisSize = MainAxisSize.max,
    this.mainAxisAlignment,
    this.crossAxisAlignment,
    this.textBaseline,
    this.behavior,
    this.textExpanded = false,
    this.textFlexible = false,
    this.widgetPadding,
    this.isSelectable = false,
    this.alignment,
    this.paragraphPadding,
    this.scrollable = false,
    this.scrollDirection,
    this.scrollPadding,
    this.cursor,
  }) : _data = null;

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
  final ContextCallback? onLongPressed;
  final int? maxLines;
  final TextAlign? textAlign;
  final TextOverflow? overflow;
  final BoxConstraints? constraints;
  final bool expanded, flexible;
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
  final MainAxisSize mainAxisSize;
  final MainAxisAlignment? mainAxisAlignment;
  final CrossAxisAlignment? crossAxisAlignment;
  final TextBaseline? textBaseline;
  final HitTestBehavior? behavior;
  final bool textExpanded;
  final bool textFlexible;
  final double? widgetPadding;
  final Alignment? alignment;
  final bool isSelectable;
  final double? paragraphPadding;
  final bool scrollable;
  final Axis? scrollDirection;
  final EdgeInsets? scrollPadding;
  final MouseCursor? cursor;

  @override
  Widget build(BuildContext context) {
    final textStyle = style ?? DefaultTextStyle.of(context).style;

    Widget _buildText(String data) {
      TextSpan textSpan = TextSpan(text: data);
      // 处理段落间距
      if (paragraphPadding != null && paragraphPadding! > 0) {
        textSpan = TextSpan(
          children: [
            for (final item in data.split('\n')) ...[
              TextSpan(text: item),
              TextSpan(
                text: '\n\n',
                style: TextStyle(
                  height: paragraphPadding! / (textStyle.fontSize ?? 14),
                ),
              ),
            ],
          ]..removeLast(),
        );
      }
      return isSelectable
          ? SelectableText.rich(
              textSpan,
              maxLines: maxLines,
              style: textStyle,
              strutStyle: strutStyle,
              textAlign: textAlign,
            )
          : Text.rich(
              textSpan,
              maxLines: maxLines,
              style: textStyle,
              strutStyle: strutStyle,
              textAlign: textAlign,
              overflow: maxLines == 1
                  ? (overflow ?? TextOverflow.ellipsis)
                  : overflow,
              softWrap: softWrap,
            );
    }

    Widget result = _data != null
        ? _buildText(_data!)
        : StreamBuilder<String>(
            stream: _stream!,
            initialData: initialData,
            builder: (_, snapshot) => _buildText(snapshot.data ?? ''),
          );

    if (scrollable) {
      result = SingleChildScrollView(
        padding: scrollPadding,
        scrollDirection: scrollDirection ?? Axis.vertical,
        child: result,
      );
    }

    if (rightWidget != null || leftWidget != null) {
      result = Row(
        mainAxisSize: mainAxisSize,
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

    if (onPressed != null || onLongPressed != null) {
      result = MouseRegion(
        cursor: cursor ?? SystemMouseCursors.click,
        child: GestureDetector(
          behavior: behavior ?? HitTestBehavior.opaque,
          onTap: onPressed != null ? () => onPressed!(context) : null,
          onLongPress:
              onLongPressed != null ? () => onLongPressed!(context) : null,
          child: result,
        ),
      );
    }

    if (visible != null) {
      result = Visibility(visible: visible!, child: result);
    }

    if (material == true) {
      result = Material(color: Colors.transparent, child: result);
    }

    if (expanded) {
      result = Expanded(child: result);
    }

    if (flexible) {
      result = Flexible(child: result);
    }

    if (sliver == true) {
      result = SliverToBoxAdapter(child: result);
    }

    return result;
  }
}
