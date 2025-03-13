import 'package:decorated_flutter/decorated_flutter.dart';
import 'package:flutter/cupertino.dart';

extension EdgeInsetsX on EdgeInsets {
  EdgeInsets withSafeArea(
    BuildContext context, {
    SafeAreaConfig? config,
  }) {
    if (config == null) return this;

    final paddingData = MediaQuery.viewPaddingOf(context);
    return copyWith(
      left: left + (config.left == true ? paddingData.left : 0),
      top: top + (config.top == true ? paddingData.top : 0),
      right: right + (config.right == true ? paddingData.right : 0),
      bottom: bottom + (config.bottom == true ? paddingData.bottom : 0),
    );
  }
}
