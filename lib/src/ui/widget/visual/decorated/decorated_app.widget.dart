import 'package:decorated_flutter/src/bloc/bloc.export.dart';
import 'package:flutter/material.dart';
import 'package:oktoast/oktoast.dart';

class DecoratedApp<B extends RootBLoC> extends StatelessWidget {
  const DecoratedApp({
    Key? key,
    required this.rootBLoC,
    required this.app,
  }) : super(key: key);

  final B rootBLoC;
  final Widget app;

  @override
  Widget build(BuildContext context) {
    return BLoCProvider<B>(
      bloc: rootBLoC,
      child: OKToast(
        duration: const Duration(seconds: 3),
        radius: 4,
        dismissOtherOnShow: true,
        animationBuilder: const Miui10AnimBuilder(),
        movingOnWindowChange: false,
        child: app,
      ),
    );
  }
}
