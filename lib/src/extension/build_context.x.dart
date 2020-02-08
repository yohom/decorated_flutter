import 'package:decorated_flutter/src/bloc/bloc.export.dart';
import 'package:flutter/material.dart';
import 'package:flutter/widgets.dart';

extension BuildContextX on BuildContext {
  T of<T extends BLoC>() {
    return BLoCProvider.of<T>(this);
  }

  void snackbar(
    String content, {
    Duration duration = const Duration(seconds: 1),
  }) {
    Scaffold.of(this).showSnackBar(SnackBar(
      content: Text(content),
      duration: duration,
      action: SnackBarAction(label: '知道了', onPressed: () {}),
    ));
  }

  FormState form() {
    return Form.of(this);
  }
}
