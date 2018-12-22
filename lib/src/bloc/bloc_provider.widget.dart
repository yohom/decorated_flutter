import 'package:flutter/material.dart';
import 'package:decorated_flutter/decorated_flutter.dart';
import 'package:decorated_flutter/src/bloc/bloc.dart';
import 'package:decorated_flutter/src/utils/page_analytics.dart';

typedef void _Init<T extends BLoC>(T bloc);

class BLoCProvider<T extends BLoC> extends StatefulWidget {
  static PageAnalytics analytics;

  BLoCProvider({
    Key key,
    @required this.child,
    @required this.bloc,
    this.init,
    this.withAnalytics = true,
  }) : super(key: key);

  final T bloc;
  final _Init<T> init;
  final Widget child;
  final bool withAnalytics;

  @override
  _BLoCProviderState<T> createState() => _BLoCProviderState<T>();

  static T of<T extends BLoC>(BuildContext context) {
    final type = _typeOf<BLoCProvider<T>>();
    BLoCProvider<T> provider = context.ancestorWidgetOfExactType(type);
    return provider.bloc;
  }

  static Type _typeOf<T>() => T;
}

class _BLoCProviderState<T extends BLoC> extends State<BLoCProvider<T>> {
  @override
  void initState() {
    super.initState();

    if (isNotEmpty(widget.init)) widget.init(widget.bloc);

    if (BLoCProvider.analytics != null && widget.withAnalytics) {
      L.p('${T.toString()} start');
      BLoCProvider.analytics.onPageStart(T.toString());
    }
  }

  @override
  Widget build(BuildContext context) => widget.child;

  @override
  void reassemble() {
    widget.bloc.reassemble();
    super.reassemble();
  }

  @override
  void dispose() {
    if (BLoCProvider.analytics != null && widget.withAnalytics) {
      BLoCProvider.analytics.onPageEnd(T.toString());
      L.p('${T.toString()} end');
    }
    widget.bloc.close();
    super.dispose();
  }
}
