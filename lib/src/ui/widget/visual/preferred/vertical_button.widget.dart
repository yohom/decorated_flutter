import 'package:decorated_flutter/decorated_flutter.dart';
import 'package:flutter/material.dart';

class VerticalButton extends StatelessWidget {
  const VerticalButton({
    super.key,
    required this.icon,
    required this.label,
    required this.onPressed,
    this.onLongPressed,
    this.spacing = 8,
    this.width,
    this.mainAxisAlignment = MainAxisAlignment.start,
    this.crossAxisAlignment = CrossAxisAlignment.center,
  });

  final Widget icon;
  final Widget label;
  final double spacing;
  final ContextCallback onPressed;
  final ContextCallback? onLongPressed;
  final double? width;
  final MainAxisAlignment mainAxisAlignment;
  final CrossAxisAlignment crossAxisAlignment;

  @override
  Widget build(BuildContext context) {
    return DecoratedColumn(
      width: width,
      mainAxisSize: MainAxisSize.min,
      onPressed: onPressed,
      onLongPressed: onLongPressed,
      itemSpacing: spacing,
      crossAxisAlignment: crossAxisAlignment,
      mainAxisAlignment: mainAxisAlignment,
      children: [
        icon,
        DefaultTextStyle(
          style: DefaultTextStyle.of(context).style,
          child: label,
        ),
      ],
    );
  }
}
