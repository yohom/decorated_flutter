import 'package:decorated_flutter/decorated_flutter.dart';
import 'package:flutter/cupertino.dart';

extension EdgeInsetsX on EdgeInsets {
  EdgeInsets withSafeArea(
    BuildContext context, {
    SafeAreaConfig config = const SafeAreaConfig(),
  }) {
    final mediaQueryData = MediaQuery.of(context);
    return copyWith(
      left: left + (config.left == true ? mediaQueryData.padding.left : 0),
      top: top + (config.top == true ? mediaQueryData.padding.top : 0),
      right: right + (config.right == true ? mediaQueryData.padding.right : 0),
      bottom:
          bottom + (config.bottom == true ? mediaQueryData.padding.bottom : 0),
    );
  }
}
