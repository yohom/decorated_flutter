import 'package:decorated_flutter/decorated_flutter.dart';
import 'package:flutter/material.dart';
import 'package:oktoast/oktoast.dart';

class DecoratedApp<B extends RootBLoC> extends StatelessWidget {
  const DecoratedApp({
    Key? key,
    required this.app,
  }) : super(key: key);

  final Widget app;

  @override
  Widget build(BuildContext context) {
    return BLoCProvider<B>(
      bloc: require(),
      child: OKToast(
        duration: const Duration(seconds: 3),
        radius: 4,
        dismissOtherOnShow: true,
        animationBuilder: const ToastAnimBuilder(),
        movingOnWindowChange: false,
        child: ListTileTheme(
          dense: true,
          tileColor: Colors.white,
          minLeadingWidth: 8,
          child: app,
        ),
      ),
    );
  }
}
