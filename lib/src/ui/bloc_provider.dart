import 'package:flutter/material.dart';
import 'package:framework/framework.dart';

class BLoCProvider<B extends BLoC> extends StatefulWidget {
  final Widget child;
  final B bloc;

  BLoCProvider({
    Key key,
    @required this.child,
    @required this.bloc,
  }) : super(key: key);

  @override
  _BLoCProviderState createState() => _BLoCProviderState();

  static B of<B extends BLoC>(BuildContext context, [bool rebuild = true]) {
    return (rebuild
            ? context.inheritFromWidgetOfExactType(_BLoCProvider)
                as _BLoCProvider
            : context.ancestorWidgetOfExactType(_BLoCProvider) as _BLoCProvider)
        .bloc;
  }
}

class _BLoCProviderState extends State<BLoCProvider> {
  @override
  Widget build(BuildContext context) {
    return _BLoCProvider(bloc: widget.bloc, child: widget.child);
  }

  @override
  void dispose() {
    widget.bloc.close();
    super.dispose();
  }
}

class _BLoCProvider<B extends BLoC> extends InheritedWidget {
  final B bloc;

  _BLoCProvider({
    Key key,
    @required this.bloc,
    @required Widget child,
  }) : super(key: key, child: child);

  @override
  bool updateShouldNotify(_BLoCProvider old) => bloc != old.bloc;
}
