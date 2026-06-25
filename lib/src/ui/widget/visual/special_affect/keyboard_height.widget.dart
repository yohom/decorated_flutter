import 'dart:async';

import 'package:decorated_flutter/decorated_flutter.dart';
import 'package:flutter/material.dart';

const _kKeyboardHeightStorageKey = 'decorated_flutter.keyboardHeight';
const _kKeyboardHeightPersistDelay = Duration(milliseconds: 150);

class KeyboardHeightObserver extends StatefulWidget {
  static double? get height {
    return gDecoratedStorage.getDouble(_kKeyboardHeightStorageKey);
  }

  const KeyboardHeightObserver({
    super.key,
    required this.child,
  });

  final Widget child;

  @override
  State<KeyboardHeightObserver> createState() => _KeyboardHeightObserverState();
}

class _KeyboardHeightObserverState extends State<KeyboardHeightObserver>
    with WidgetsBindingObserver {
  Timer? _persistTimer;
  double _pendingKeyboardHeight = 0;

  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance.addObserver(this);
    WidgetsBinding.instance.addPostFrameCallback((_) {
      if (!mounted) {
        return;
      }
      _schedulePersist(_readKeyboardHeight());
    });
  }

  @override
  void didChangeMetrics() {
    _schedulePersist(_readKeyboardHeight());
  }

  @override
  Widget build(BuildContext context) {
    return widget.child;
  }

  @override
  void dispose() {
    _persistTimer?.cancel();
    WidgetsBinding.instance.removeObserver(this);
    super.dispose();
  }

  double _readKeyboardHeight() {
    final view = View.of(context);
    return EdgeInsets.fromViewPadding(
      view.viewInsets,
      view.devicePixelRatio,
    ).bottom;
  }

  void _schedulePersist(double keyboardHeight) {
    if (keyboardHeight <= 100) {
      _persistTimer?.cancel();
      return;
    }

    _pendingKeyboardHeight = keyboardHeight;
    _persistTimer?.cancel();
    _persistTimer = Timer(_kKeyboardHeightPersistDelay, _persistKeyboardHeight);
  }

  void _persistKeyboardHeight() {
    if (!mounted || _pendingKeyboardHeight <= 0) {
      return;
    }

    if (KeyboardHeightObserver.height == _pendingKeyboardHeight) {
      return;
    }

    L.d('[DECORATED_FLUTTER] 捕捉到键盘高度: $_pendingKeyboardHeight');
    gDecoratedStorage.setDouble(
      _kKeyboardHeightStorageKey,
      _pendingKeyboardHeight,
    );
  }
}
