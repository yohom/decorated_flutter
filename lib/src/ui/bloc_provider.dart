import 'package:flutter/material.dart';
import 'package:framework/src/utils/bloc.dart';

class BLoCProvider<T extends BLoC> extends StatefulWidget {
  BLoCProvider({
    Key key,
    @required this.child,
    @required this.bloc,
  }) : super(key: key);

  final T bloc;
  final Widget child;

  @override
  _BlocProviderState<T> createState() => _BlocProviderState<T>();

  static T of<T extends BLoC>(BuildContext context) {
    final type = _typeOf<BLoCProvider<T>>();
    BLoCProvider<T> provider = context.ancestorWidgetOfExactType(type);
    return provider.bloc;
  }

  static Type _typeOf<T>() => T;
}

class _BlocProviderState<T> extends State<BLoCProvider<BLoC>> {
  @override
  Widget build(BuildContext context) {
    return widget.child;
  }

  @override
  void dispose() {
    widget.bloc.close();
    super.dispose();
  }
}
