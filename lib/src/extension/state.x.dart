import 'package:flutter/material.dart';

extension StateX on State {
  void setStateSafely(VoidCallback cb) {
    if (mounted) {
      // ignore: invalid_use_of_protected_member
      setState(cb);
    }
  }
}
