import 'package:flutter/material.dart';

class DecoratedWrap extends StatelessWidget {
  const DecoratedWrap({
    Key? key,
    this.direction = Axis.horizontal,
    this.alignment = WrapAlignment.start,
    this.runAlignment = WrapAlignment.start,
    this.spacing = 0.0,
    this.runSpacing = 0.0,
    this.crossAxisAlignment = WrapCrossAlignment.start,
    this.textDirection,
    this.verticalDirection = VerticalDirection.down,
    this.clipBehavior = Clip.none,
    required this.crossAxisCount,
    required this.children,
  }) : super(key: key);

  final int crossAxisCount;
  final Axis direction;
  final WrapAlignment alignment;
  final WrapAlignment runAlignment;
  final double spacing;
  final double runSpacing;
  final WrapCrossAlignment crossAxisAlignment;
  final TextDirection? textDirection;
  final VerticalDirection verticalDirection;
  final Clip clipBehavior;
  final List<Widget> children;

  @override
  Widget build(BuildContext context) {
    return LayoutBuilder(
      builder: (context, constraints) {
        final availableWidth = constraints.maxWidth - crossAxisCount * spacing;
        final itemWidth = availableWidth / crossAxisCount;
        return Wrap(
          direction: direction,
          alignment: alignment,
          runAlignment: runAlignment,
          runSpacing: runSpacing,
          spacing: spacing,
          crossAxisAlignment: crossAxisAlignment,
          textDirection: textDirection,
          verticalDirection: verticalDirection,
          clipBehavior: clipBehavior,
          children: [
            for (final item in children)
              SizedBox(width: itemWidth, child: item),
          ],
        );
      },
    );
  }
}
