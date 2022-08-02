// ignore_for_file: invalid_use_of_protected_member

import 'package:flutter/material.dart';

import '../utils/utils.export.dart';

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
    } else {
      L.w('State在销毁时后调用setState! 请检查逻辑是否正确');
    }
  }
}
