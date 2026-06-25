import 'package:decorated_flutter/src/utils/logger/logger.dart';
import 'package:flutter/widgets.dart';

mixin KeyboardHeightMixin<T extends StatefulWidget>
    on State<T>, WidgetsBindingObserver {
  @protected
  double keyboardHeight = 0;

  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance.addObserver(this);
  }

  @override
  void didChangeMetrics() {
    final keyboardHeight = EdgeInsets.fromViewPadding(
            View.of(context).viewInsets, View.of(context).devicePixelRatio)
        .bottom;
    if (keyboardHeight == this.keyboardHeight) {
      return;
    }
    L.i('[DECORATED_FLUTTER] 键盘高度发生变化: $keyboardHeight');

    setState(() {
      this.keyboardHeight = keyboardHeight;
    });
  }

  @override
  void dispose() {
    WidgetsBinding.instance.removeObserver(this);
    super.dispose();
  }
}
