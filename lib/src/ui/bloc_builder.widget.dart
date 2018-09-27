import 'package:flutter/material.dart';
import 'package:framework/framework.dart';

typedef Widget _Builder<B extends BLoC>(BuildContext context, B bloc);

class BLoCBuilder<B extends BLoC> extends StatelessWidget {
  const BLoCBuilder({
    Key key,
    this.builder,
    this.bloc,
  }) : super(key: key);

  final _Builder builder;
  final B bloc;

  @override
  Widget build(BuildContext context) {
    return BLoCProvider(child: builder(context, bloc), bloc: bloc);
  }
}
