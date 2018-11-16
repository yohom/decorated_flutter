import 'package:flutter/material.dart';
import 'package:framework/framework.dart';
import 'package:framework/src/bloc/bloc.dart';
import 'package:framework/src/utils/page_analytics.dart';

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

  /// 注册一个页面分析器
  static void setPageAnalytics(PageAnalytics analytics) {
    BLoCProvider.analytics = analytics;
  }

  static Type _typeOf<T>() => T;
}

class _BLoCProviderState<T extends BLoC> extends State<BLoCProvider<T>> {
  @override
  void initState() {
    super.initState();

    if (isNotEmpty(widget.init)) widget.init(widget.bloc);

    if (BLoCProvider.analytics != null && widget.withAnalytics) {
      BLoCProvider.analytics.onPageStart();
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
      BLoCProvider.analytics.onPageEnd();
    }
    widget.bloc.close();
    super.dispose();
  }
}
