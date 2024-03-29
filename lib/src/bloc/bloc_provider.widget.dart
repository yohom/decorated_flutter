import 'package:decorated_flutter/decorated_flutter.dart';
import 'package:flutter/material.dart';

class BLoCProvider<T extends BLoC> extends StatefulWidget {
  const BLoCProvider({
    super.key,
    required this.child,
    required this.bloc,
    this.init,
    this.onDispose,
    @Deprecated('使用canDispose代替, 灵活性更好') this.autoDispose = true,
    this.canDispose = returnTrue,
  });

  const BLoCProvider.borrowed({
    super.key,
    required this.child,
    required this.bloc,
    this.init,
    this.onDispose,
  })  : autoDispose = false,
        canDispose = returnFalse;

  final T bloc;
  final ValueChanged<T>? init;
  final Widget child;
  final VoidCallback? onDispose;
  @Deprecated('使用canDispose代替, 灵活性更好')
  final bool autoDispose;
  final bool Function() canDispose;

  @override
  _BLoCProviderState<T> createState() => _BLoCProviderState<T>();

  static T? of<T extends BLoC>(BuildContext context) {
    final provider = context
        .getElementForInheritedWidgetOfExactType<_BLoCProviderInherited<T>>()
        ?.widget as _BLoCProviderInherited<T>?;
    return provider?.bloc;
  }
}

class _BLoCProviderState<T extends BLoC> extends State<BLoCProvider<T>> {
  @override
  void initState() {
    super.initState();
    widget.init?.call(widget.bloc);
    widget.bloc.init();
  }

  @override
  void didUpdateWidget(covariant BLoCProvider<T> oldWidget) {
    super.didUpdateWidget(oldWidget);
    if (widget.bloc != oldWidget.bloc) {
      widget.init?.call(widget.bloc);
      widget.bloc.init();
    }
  }

  @override
  Widget build(BuildContext context) {
    return _BLoCProviderInherited(bloc: widget.bloc, child: widget.child);
  }

  @override
  void dispose() {
    if (widget.canDispose() && widget.autoDispose) {
      widget.bloc.dispose();
      widget.onDispose?.call();
    }

    super.dispose();
  }
}

class _BLoCProviderInherited<T> extends InheritedWidget {
  const _BLoCProviderInherited({
    super.key,
    required super.child,
    required this.bloc,
  });

  final T bloc;

  @override
  bool updateShouldNotify(_BLoCProviderInherited oldWidget) {
    return bloc != oldWidget.bloc;
  }
}
