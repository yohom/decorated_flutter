import 'dart:async';

import 'package:decorated_flutter/src/utils/logger/logger.dart';
import 'package:decorated_flutter/src/utils/objects.dart';
import 'package:flutter/widgets.dart';

const _kKeyboardHeightStorageKey = 'decorated_flutter.keyboardHeight';
const _kKeyboardHeightStableDelay = Duration(milliseconds: 250);
const _kKeyboardHeightZeroThreshold = 100.0;

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

  final Widget Function(double realtimeHeight, double stableHeight) builder;

  @override
  State<KeyboardHeightBuilder> createState() => _KeyboardHeightBuilderState();
}

class _KeyboardHeightBuilderState extends State<KeyboardHeightBuilder>
    with WidgetsBindingObserver {
  Timer? _stableKeyboardHeightTimer;
  double _pendingKeyboardHeight = 0;
  late double _keyboardHeight = _cachedKeyboardHeight;
  late double _stableKeyboardHeight = _cachedKeyboardHeight;

  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance.addObserver(this);
    WidgetsBinding.instance.addPostFrameCallback((_) {
      if (!mounted) {
        return;
      }
      _handleKeyboardHeightChange(_readKeyboardHeight());
    });
  }

  @override
  void didChangeMetrics() {
    _handleKeyboardHeightChange(_readKeyboardHeight());
  }

  @override
  void dispose() {
    _stableKeyboardHeightTimer?.cancel();
    WidgetsBinding.instance.removeObserver(this);
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return widget.builder(_keyboardHeight, _stableKeyboardHeight);
  }

  double _readKeyboardHeight() {
    final rawKeyboardHeight = EdgeInsets.fromViewPadding(
      View.of(context).viewInsets,
      View.of(context).devicePixelRatio,
    ).bottom;
    if (rawKeyboardHeight < _kKeyboardHeightZeroThreshold) {
      return 0;
    }
    return rawKeyboardHeight;
  }

  void _handleKeyboardHeightChange(double nextKeyboardHeight) {
    _scheduleStableKeyboardHeight(nextKeyboardHeight);

    if (nextKeyboardHeight == _keyboardHeight) {
      return;
    }

    // L.i('[DECORATED_FLUTTER] 键盘高度发生变化: $nextKeyboardHeight');

    setState(() {
      _keyboardHeight = nextKeyboardHeight;
    });
  }

  void _scheduleStableKeyboardHeight(double nextKeyboardHeight) {
    if (nextKeyboardHeight <= 0) {
      _stableKeyboardHeightTimer?.cancel();
      return;
    }

    _pendingKeyboardHeight = nextKeyboardHeight;
    _stableKeyboardHeightTimer?.cancel();
    _stableKeyboardHeightTimer = Timer(
      _kKeyboardHeightStableDelay,
      _updateStableKeyboardHeight,
    );
  }

  void _updateStableKeyboardHeight() {
    if (!mounted) {
      return;
    }

    final nextStableKeyboardHeight = _pendingKeyboardHeight;
    if (nextStableKeyboardHeight == _stableKeyboardHeight) {
      return;
    }

    if (nextStableKeyboardHeight > 0 &&
        nextStableKeyboardHeight != _cachedKeyboardHeight) {
      L.i('[DECORATED_FLUTTER] 缓存键盘高度: $nextStableKeyboardHeight');
      gDecoratedStorage.setDouble(
        _kKeyboardHeightStorageKey,
        nextStableKeyboardHeight,
      );
    }

    L.i('[DECORATED_FLUTTER] 稳定键盘高度发生变化: $nextStableKeyboardHeight');
    setState(() {
      _stableKeyboardHeight = nextStableKeyboardHeight;
    });
  }

  double get _cachedKeyboardHeight {
    return gDecoratedStorage.getDouble(_kKeyboardHeightStorageKey) ?? 0;
  }
}
