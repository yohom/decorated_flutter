import 'package:flutter/material.dart';

/// 文本溢出时，在最后一行尾部展示自定义组件。
class OverflowText extends StatefulWidget {
  const OverflowText(
    this.text, {
    required this.overflowWidget,
    super.key,
    this.maxLines = 1,
    this.style,
    this.textAlign,
    this.textDirection,
    this.textScaler,
    this.strutStyle,
    this.textWidthBasis = TextWidthBasis.parent,
    this.textHeightBehavior,
    this.locale,
  }) : assert(maxLines > 0);

  final String text;
  final Widget overflowWidget;
  final int maxLines;
  final TextStyle? style;
  final TextAlign? textAlign;
  final TextDirection? textDirection;
  final TextScaler? textScaler;
  final StrutStyle? strutStyle;
  final TextWidthBasis textWidthBasis;
  final TextHeightBehavior? textHeightBehavior;
  final Locale? locale;

  @override
  State<OverflowText> createState() => _OverflowTextState();
}

class _OverflowTextState extends State<OverflowText> {
  final _overflowWidgetKey = GlobalKey();
  Size? _overflowWidgetSize;
  double? _maxWidth;

  @override
  void didUpdateWidget(covariant OverflowText oldWidget) {
    super.didUpdateWidget(oldWidget);
    if (oldWidget.overflowWidget != widget.overflowWidget) {
      _overflowWidgetSize = null;
    }
  }

  @override
  void didChangeDependencies() {
    super.didChangeDependencies();
    _overflowWidgetSize = null;
  }

  @override
  Widget build(BuildContext context) {
    return LayoutBuilder(
      builder: (context, constraints) {
        if (_maxWidth != constraints.maxWidth) {
          _maxWidth = constraints.maxWidth;
          _overflowWidgetSize = null;
        }
        final textDirection =
            widget.textDirection ?? Directionality.of(context);
        final textStyle =
            DefaultTextStyle.of(context).style.merge(widget.style);
        final textScaler =
            widget.textScaler ?? MediaQuery.textScalerOf(context);

        if (!constraints.hasBoundedWidth) {
          return _buildPlainText(textDirection, textScaler);
        }

        final textPainter = _createTextPainter(
          text: TextSpan(text: widget.text, style: textStyle),
          textDirection: textDirection,
          textScaler: textScaler,
        )..layout(maxWidth: constraints.maxWidth);
        final isOverflowed = textPainter.didExceedMaxLines;
        textPainter.dispose();

        if (!isOverflowed) return _buildPlainText(textDirection, textScaler);

        final overflowWidgetSize = _overflowWidgetSize;
        if (overflowWidgetSize == null) {
          _measureOverflowWidget();
          return Stack(
            clipBehavior: Clip.none,
            children: [
              _buildPlainText(textDirection, textScaler),
              Positioned(
                left: 0,
                top: 0,
                child: IgnorePointer(
                  child: Opacity(
                    opacity: 0,
                    child: KeyedSubtree(
                      key: _overflowWidgetKey,
                      child: widget.overflowWidget,
                    ),
                  ),
                ),
              ),
            ],
          );
        }

        final ellipsisPainter = _createTextPainter(
          text: TextSpan(text: '…', style: textStyle),
          textDirection: textDirection,
          textScaler: textScaler,
        )..layout();
        final fitsWithEllipsis =
            ellipsisPainter.width + overflowWidgetSize.width <=
                constraints.maxWidth;
        ellipsisPainter.dispose();
        if (!fitsWithEllipsis) {
          return SizedBox(
            width: constraints.maxWidth,
            child: FittedBox(
              fit: BoxFit.scaleDown,
              alignment: AlignmentDirectional.centerStart,
              child: widget.overflowWidget,
            ),
          );
        }

        final truncatedText = _truncateText(
          maxWidth: constraints.maxWidth,
          textStyle: textStyle,
          textDirection: textDirection,
          textScaler: textScaler,
          overflowWidgetSize: overflowWidgetSize,
        );
        return RichText(
          text: TextSpan(
            style: textStyle,
            children: [
              TextSpan(text: truncatedText),
              const TextSpan(text: '…'),
              WidgetSpan(
                alignment: PlaceholderAlignment.middle,
                child: widget.overflowWidget,
              ),
            ],
          ),
          textAlign: widget.textAlign ?? TextAlign.start,
          textDirection: textDirection,
          textScaler: textScaler,
          maxLines: widget.maxLines,
          overflow: TextOverflow.clip,
          strutStyle: widget.strutStyle,
          textWidthBasis: widget.textWidthBasis,
          textHeightBehavior: widget.textHeightBehavior,
          locale: widget.locale,
        );
      },
    );
  }

  Widget _buildPlainText(TextDirection textDirection, TextScaler textScaler) {
    return Text(
      widget.text,
      style: widget.style,
      textAlign: widget.textAlign,
      textDirection: textDirection,
      textScaler: textScaler,
      maxLines: widget.maxLines,
      overflow: TextOverflow.ellipsis,
      strutStyle: widget.strutStyle,
      textWidthBasis: widget.textWidthBasis,
      textHeightBehavior: widget.textHeightBehavior,
      locale: widget.locale,
    );
  }

  TextPainter _createTextPainter({
    required InlineSpan text,
    required TextDirection textDirection,
    required TextScaler textScaler,
    List<PlaceholderDimensions>? placeholderDimensions,
  }) {
    return TextPainter(
      text: text,
      textAlign: widget.textAlign ?? TextAlign.start,
      textDirection: textDirection,
      textScaler: textScaler,
      maxLines: widget.maxLines,
      strutStyle: widget.strutStyle,
      textWidthBasis: widget.textWidthBasis,
      textHeightBehavior: widget.textHeightBehavior,
      locale: widget.locale,
    )..setPlaceholderDimensions(placeholderDimensions);
  }

  String _truncateText({
    required double maxWidth,
    required TextStyle textStyle,
    required TextDirection textDirection,
    required TextScaler textScaler,
    required Size overflowWidgetSize,
  }) {
    var offset = 0;
    final boundaries = <int>[0];
    for (final character in widget.text.characters) {
      offset += character.length;
      boundaries.add(offset);
    }

    var start = 0;
    var end = boundaries.length - 1;
    while (start < end) {
      final middle = (start + end + 1) ~/ 2;
      final painter = _createTextPainter(
        text: TextSpan(
          style: textStyle,
          children: [
            TextSpan(text: widget.text.substring(0, boundaries[middle])),
            const TextSpan(text: '…'),
            const WidgetSpan(child: SizedBox()),
          ],
        ),
        textDirection: textDirection,
        textScaler: textScaler,
        placeholderDimensions: [
          PlaceholderDimensions(
            size: overflowWidgetSize,
            alignment: PlaceholderAlignment.middle,
          ),
        ],
      )..layout(maxWidth: maxWidth);
      final fits = !painter.didExceedMaxLines;
      painter.dispose();

      if (fits) {
        start = middle;
      } else {
        end = middle - 1;
      }
    }
    return widget.text.substring(0, boundaries[start]);
  }

  void _measureOverflowWidget() {
    WidgetsBinding.instance.addPostFrameCallback((_) {
      final renderBox =
          _overflowWidgetKey.currentContext?.findRenderObject() as RenderBox?;
      final size = renderBox?.size;
      if (!mounted || size == null || size == _overflowWidgetSize) return;
      setState(() => _overflowWidgetSize = size);
    });
  }
}
