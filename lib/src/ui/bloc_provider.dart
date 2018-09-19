import 'package:flutter/material.dart';
import 'package:framework/framework.dart';

/// 局部BLoCProvider, 以和全局的BLoCProvider区分
class LocalBLoCProvider<B extends BLoC> extends StatefulWidget {
  final Widget child;
  final B bloc;

  LocalBLoCProvider({
    Key key,
    @required this.child,
    @required this.bloc,
  }) : super(key: key);

  @override
  _LocalBLoCProviderState createState() => _LocalBLoCProviderState();

  static B of<B extends BLoC>(BuildContext context, [bool rebuild = true]) {
    return (rebuild
            ? context.inheritFromWidgetOfExactType(_LocalBLoCProvider)
                as _LocalBLoCProvider
            : context.ancestorWidgetOfExactType(_LocalBLoCProvider)
                as _LocalBLoCProvider)
        .bloc;
  }
}

class _LocalBLoCProviderState extends State<LocalBLoCProvider> {
  @override
  Widget build(BuildContext context) {
    return _LocalBLoCProvider(bloc: widget.bloc, child: widget.child);
  }

  @override
  void dispose() {
    widget.bloc.close();
    super.dispose();
  }
}

class _LocalBLoCProvider<B extends BLoC> extends InheritedWidget {
  final B bloc;

  _LocalBLoCProvider({
    Key key,
    @required this.bloc,
    @required Widget child,
  }) : super(key: key, child: child);

  @override
  bool updateShouldNotify(_LocalBLoCProvider old) => bloc != old.bloc;
}

/// 全局BLoCProvider, 以和局部的BLoCProvider区分
class GlobalBLoCProvider<B extends BLoC> extends StatefulWidget {
  final Widget child;
  final B bloc;

  GlobalBLoCProvider({
    Key key,
    @required this.child,
    @required this.bloc,
  }) : super(key: key);

  @override
  _GlobalBLoCProviderState createState() => _GlobalBLoCProviderState();

  static B of<B extends BLoC>(BuildContext context, [bool rebuild = true]) {
    return (rebuild
            ? context.inheritFromWidgetOfExactType(_GlobalBLoCProvider)
                as _GlobalBLoCProvider
            : context.ancestorWidgetOfExactType(_GlobalBLoCProvider)
                as _GlobalBLoCProvider)
        .bloc;
  }
}

class _GlobalBLoCProviderState extends State<GlobalBLoCProvider> {
  @override
  Widget build(BuildContext context) {
    return _GlobalBLoCProvider(bloc: widget.bloc, child: widget.child);
  }

  @override
  void dispose() {
    widget.bloc.close();
    super.dispose();
  }
}

class _GlobalBLoCProvider<B extends BLoC> extends InheritedWidget {
  final B bloc;

  _GlobalBLoCProvider({
    Key key,
    @required this.bloc,
    @required Widget child,
  }) : super(key: key, child: child);

  @override
  bool updateShouldNotify(_GlobalBLoCProvider old) => bloc != old.bloc;
}
