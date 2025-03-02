import 'package:decorated_flutter/src/bloc/bloc.dart';
import 'package:flutter/material.dart';

typedef ContextCallback = void Function(BuildContext context);
typedef ContextValueChanged<T> = void Function(BuildContext context, T value);
typedef InitCallback<T extends BLoC> = void Function(T bloc);
typedef LateInitCallback<T extends BLoC> = void Function(
    T bloc, BuildContext context);
typedef SearchKeywordCallback<T> = bool Function(T, String keyword);
typedef FutureCallback = Future<void> Function();
typedef WidgetValueBuilder<T> = Widget Function(BuildContext context, T value);
