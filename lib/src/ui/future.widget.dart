import 'dart:async';

import 'package:flutter/material.dart';
import 'package:meta/meta.dart';

import '../framework.dart';
import 'error.widget.dart' as ui;

typedef Widget FutureWidgetBuilder<DATA>(DATA data);

class FutureWidget<T> extends StatelessWidget {
  final Future<T> future;
  final FutureWidgetBuilder<T> builder;
  final bool showLoading;
  final T initialData;
  final bool isExpanded;

  const FutureWidget({
    Key key,
    @required this.future,
    @required this.builder,
    this.showLoading = true,
    this.isExpanded = false,
    this.initialData,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return FutureBuilder<T>(
      initialData: initialData,
      future: future,
      builder: (ctx, snapshot) {
        if (snapshot.hasError) {
          return ui.ErrorWidget(message: snapshot.error.toString());
        }

        if (snapshot.hasData) {
          return builder(snapshot.data);
        } else if (showLoading) {
          return LoadingWidget();
        } else if (isExpanded) {
          return Expanded(child: EmptyWidget());
        } else {
          return EmptyWidget();
        }
      },
    );
  }
}
