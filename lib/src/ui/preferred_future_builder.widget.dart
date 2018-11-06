import 'dart:async';

import 'package:flutter/material.dart';
import 'package:framework/framework.dart';
import 'package:meta/meta.dart';

typedef Widget _Builder<DATA>(DATA data);

/// **Preferred**表达的语义是对目标widget预定义了一些参数
/// **Decorated**表达的语义是对目标widget进行了一些外围的包装
class PreferredFutureBuilder<T> extends StatelessWidget {
  static Widget defaultEmptyPlaceholder;
  static Widget defaultErrorPlaceholder;

  final Future<T> future;
  final _Builder<T> builder;
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

  const PreferredFutureBuilder({
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

@Deprecated('用DecoratedFutureBuilder代替, 只是简单的名称代替, 这个类不再维护')
class FutureWidget<T> extends StatelessWidget {
  static Widget defaultEmptyPlaceholder;
  static Widget defaultErrorPlaceholder;

  final Future<T> future;
  final _Builder<T> builder;
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
