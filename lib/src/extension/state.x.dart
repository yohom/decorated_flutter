// ignore_for_file: invalid_use_of_protected_member

import 'package:flutter/material.dart';

extension StateX on State {
  void setStateSafely(VoidCallback cb, {bool nextFrame = false}) {
    if (mounted) {
      if (nextFrame) {
        WidgetsBinding.instance.addPostFrameCallback((_) {
          if (mounted) setState(cb);
        });
      } else {
        setState(cb);
      }
    }
  }
}
