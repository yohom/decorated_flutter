import 'dart:ui';

import 'package:decorated_flutter/src/bloc/bloc.export.dart';
import 'package:flutter/material.dart';
import 'package:flutter/rendering.dart';
import 'package:flutter/widgets.dart';

extension BuildContextX on BuildContext {
  T of<T extends BLoC>() {
    return BLoCProvider.of<T>(this)!;
  }

  T? maybeOf<T extends BLoC>() {
    return BLoCProvider.of<T>(this);
  }

  ThemeData get theme {
    return Theme.of(this);
  }

  bool get isDarkMode {
    return Theme.of(this).brightness == Brightness.dark;
  }

  void clearFocus() {
    FocusScope.of(this).unfocus();
  }

  FormState? get form {
    return Form.of(this);
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

  NavigatorState get rootNavigator {
    return Navigator.of(this, rootNavigator: true);
  }

  NavigatorState get navigator {
    return Navigator.of(this);
  }

  TabController? get tabController {
    return DefaultTabController.of(this);
  }
}
