import 'package:decorated_flutter/decorated_flutter.dart';
import 'package:flutter/material.dart';

class VerticalButton extends StatelessWidget {
  const VerticalButton({
    Key? key,
    required this.icon,
    required this.label,
    required this.onPressed,
    this.onLongPressed,
    this.spacing = 8,
    this.width,
    this.mainAxisAlignment = MainAxisAlignment.start,
  }) : super(key: key);

  final Widget icon;
  final Widget label;
  final double spacing;
  final ContextCallback onPressed;
  final ContextCallback? onLongPressed;
  final double? width;
  final MainAxisAlignment mainAxisAlignment;

  @override
  Widget build(BuildContext context) {
    return DecoratedColumn(
      width: width,
      mainAxisSize: MainAxisSize.min,
      onPressed: onPressed,
      onLongPressed: onLongPressed,
      itemSpacing: spacing,
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
