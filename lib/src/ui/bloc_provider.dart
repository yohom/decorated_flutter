import 'package:flutter/material.dart';

import '../../app/bloc/bloc.dart';

class BlocProvider extends StatefulWidget {
  final Widget child;
  final Bloc bloc;

  BlocProvider({
    Key key,
    @required this.child,
    @required this.bloc,
  }) : super(key: key);

  @override
  _BlocProviderState createState() => _BlocProviderState();

  static Bloc of(BuildContext context, [bool rebuild = true]) {
    return (rebuild
            ? context.inheritFromWidgetOfExactType(_BlocProvider)
                as _BlocProvider
            : context.ancestorWidgetOfExactType(_BlocProvider) as _BlocProvider)
        .bloc;
  }
}

class _BlocProviderState extends State<BlocProvider> {
  @override
  Widget build(BuildContext context) {
    return _BlocProvider(bloc: widget.bloc, child: widget.child);
  }

  @override
  void dispose() {
    widget.bloc.close();
    super.dispose();
  }
}

class _BlocProvider extends InheritedWidget {
  final Bloc bloc;

  _BlocProvider({
    Key key,
    @required this.bloc,
    @required Widget child,
  }) : super(key: key, child: child);

  @override
  bool updateShouldNotify(_BlocProvider old) => bloc != old.bloc;
}
