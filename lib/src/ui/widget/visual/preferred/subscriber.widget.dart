import 'dart:async';

import 'package:decorated_flutter/decorated_flutter.dart';
import 'package:decorated_flutter/src/ui/widget/visual/placeholder/empty_placeholder.widget.dart';
import 'package:flutter/material.dart';

import '../placeholder/error_placeholder.widget.dart';

typedef Widget _Builder<DATA>(DATA data);
typedef Widget _ErrorPlaceholderBuilder(BuildContext context, Object error);

class Subscriber<T> extends StatelessWidget {
  static Widget defaultEmptyPlaceholder;
  static Widget defaultErrorPlaceholder;

  static void setDefaultPlaceholder({
    Widget emptyPlaceholder,
    Widget errorPlaceholder,
  }) {
    defaultEmptyPlaceholder = emptyPlaceholder;
    defaultErrorPlaceholder = errorPlaceholder;
  }

  const Subscriber({
    Key key,
    @required this.stream,
    @required this.builder,
    this.showLoading = true,
    this.initialData,
    this.isSliver = false,
    this.emptyPlaceholder,
    this.errorPlaceholderBuilder,
    this.loadingPlaceholder,
  }) : super(key: key);

  final Stream<T> stream;
  final _Builder<T> builder;
  final bool showLoading;
  final T initialData;
  final Widget emptyPlaceholder;
  final _ErrorPlaceholderBuilder errorPlaceholderBuilder;
  final Widget loadingPlaceholder;
  final bool isSliver;

  @override
  Widget build(BuildContext context) {
    return StreamBuilder<T>(
      initialData: initialData,
      stream: stream,
      builder: (ctx, snapshot) {
        if (snapshot.hasError) {
          L.d('Subscriber出现错误: ${snapshot.error}');
          if (snapshot.error is Error) {
            L.d((snapshot.error as Error).stackTrace);
          }
          if (errorPlaceholderBuilder != null) {
            return errorPlaceholderBuilder(context, snapshot.error);
          } else {
            return defaultErrorPlaceholder ?? isSliver
                ? SliverToBoxAdapter(child: const ErrorPlaceholder())
                : const ErrorPlaceholder();
          }
        }

        if (snapshot.hasData) {
          if (isEmpty(snapshot.data)) {
            return emptyPlaceholder ?? defaultEmptyPlaceholder ?? isSliver
                ? SliverToBoxAdapter(child: const EmptyPlaceholder())
                : const EmptyPlaceholder();
          } else {
            return builder(snapshot.data);
          }
        } else if (showLoading) {
          return loadingPlaceholder ?? isSliver
              ? SliverToBoxAdapter(child: LoadingWidget())
              : LoadingWidget();
        } else {
          return isSliver
              ? SliverToBoxAdapter(child: SizedBox.shrink())
              : SizedBox.shrink();
        }
      },
    );
  }
}
