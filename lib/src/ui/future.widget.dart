import 'dart:async';

import 'package:flutter/material.dart';
import 'package:framework/framework.dart';
import 'package:meta/meta.dart';

typedef Widget FutureWidgetBuilder<DATA>(DATA data);

class FutureWidget<T> extends StatelessWidget {
  static Widget defaultEmptyPlaceholder;
  static Widget defaultErrorPlaceholder;

  final Future<T> future;
  final FutureWidgetBuilder<T> builder;
  final bool showLoading;
  final T initialData;
  final bool isExpanded;
  final Widget emptyPlaceholder;
  final Widget errorPlaceholder;

  static void setDefaultPlaceholder({
    Widget emptyPlaceholder,
    Widget errorPlaceholder,
  }) {
    defaultEmptyPlaceholder = emptyPlaceholder;
    defaultErrorPlaceholder = errorPlaceholder;
  }

  const FutureWidget({
    Key key,
    @required this.future,
    @required this.builder,
    this.showLoading = true,
    this.isExpanded = false,
    this.initialData,
    this.emptyPlaceholder,
    this.errorPlaceholder,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return FutureBuilder<T>(
      initialData: initialData,
      future: future,
      builder: (ctx, snapshot) {
        if (snapshot.hasError) {
          return errorPlaceholder ??
              defaultErrorPlaceholder ??
              const ErrorPlaceholder();
        }

        if (snapshot.hasData) {
          if (isEmpty(snapshot.data)) {
            return emptyPlaceholder ??
                defaultEmptyPlaceholder ??
                const EmptyPlaceholder();
          } else {
            return builder(snapshot.data);
          }
        } else if (showLoading) {
          return LoadingWidget();
        } else if (isExpanded) {
          return Expanded(child: SizedBox.shrink());
        } else {
          return SizedBox.shrink();
        }
      },
    );
  }
}
