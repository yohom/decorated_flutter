import 'package:flutter/material.dart';
import 'package:framework/framework.dart';

typedef Widget _Builder<B extends BLoC>(BuildContext context, B bloc);

/// 作用与[BLoCProvider]一致, 只不过提供了一个带有bloc参数的方法
@Deprecated('init的作用被BLoCProvider代替')
class BLoCBuilder<B extends BLoC> extends StatelessWidget {
  const BLoCBuilder({
    Key key,
    @required this.builder,
    @required this.bloc,
  }) : super(key: key);

  final _Builder<B> builder;
  final B bloc;

  @override
  Widget build(BuildContext context) {
    return AutoCloseKeyboard(
      child: BLoCProvider(
        child: builder(context, bloc),
        bloc: bloc,
      ),
    );
  }
}
