import 'package:decorated_flutter/decorated_flutter.dart';
import 'package:decorated_flutter/src/bloc/bloc.dart';
import 'package:flutter/material.dart';

class BLoCProvider<T extends BLoC> extends StatefulWidget {
  const BLoCProvider({
    Key? key,
    required this.child,
    required this.bloc,
    this.init,
    this.onDispose,
    this.autoDispose = true,
  }) : super(key: key);

  final T bloc;
  final ValueChanged<T>? init;
  final Widget child;
  final VoidCallback? onDispose;
  final bool autoDispose;

  @override
  _BLoCProviderState<T> createState() => _BLoCProviderState<T>();

  static T? of<T extends BLoC>(BuildContext context) {
    final provider =
        context.findAncestorStateOfType<_BLoCProviderState<T>>()?.widget;
    return provider?.bloc;
  }
}

class _BLoCProviderState<T extends BLoC> extends State<BLoCProvider<T>> {
  @override
  void initState() {
    super.initState();
    if (widget.init != null) widget.init!(widget.bloc);
  }

  @override
  Widget build(BuildContext context) => widget.child;

  @override
  void dispose() {
    if (widget.autoDispose) {
      widget.bloc.dispose();
    }

    if (widget.onDispose != null) {
      widget.onDispose!();
    }
    super.dispose();
  }
}
