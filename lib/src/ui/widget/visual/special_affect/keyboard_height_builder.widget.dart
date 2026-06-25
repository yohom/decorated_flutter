import 'package:decorated_flutter/src/mixin/mixin.export.dart';
import 'package:flutter/widgets.dart';

/// Builds (and rebuilds) a [builder] with the current height of the software keyboard.
///
/// There's no explicit property for the software keyboard height. This builder uses
/// `EdgeInsets.fromViewPadding(View.of(context).viewInsets, View.of(context).devicePixelRatio).bottom`
/// as a proxy for the height of the software keyboard.
class KeyboardHeightBuilder extends StatefulWidget {
  const KeyboardHeightBuilder({
    super.key,
    required this.builder,
  });

  final Widget Function(BuildContext, double keyboardHeight) builder;

  @override
  State<KeyboardHeightBuilder> createState() => _KeyboardHeightBuilderState();
}

class _KeyboardHeightBuilderState extends State<KeyboardHeightBuilder>
    with WidgetsBindingObserver, KeyboardHeightMixin<KeyboardHeightBuilder> {
  @override
  Widget build(BuildContext context) {
    return widget.builder(context, keyboardHeight);
  }
}
