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

  NavigatorState navigator() {
    return Navigator.of(this);
  }

  double get height {
    return MediaQuery.of(this).size.height;
  }

  double get width {
    return MediaQuery.of(this).size.width;
  }

  EdgeInsets get padding {
    return MediaQuery.of(this).padding;
  }

  Size get size {
    return MediaQuery.of(this).size;
  }

  TextTheme get textTheme {
    return Theme.of(this).textTheme;
  }

  Color get backgroundColor {
    return Theme.of(this).backgroundColor;
  }
}
