import 'package:flutter/material.dart';
import 'package:framework/framework.dart';
import 'package:meta/meta.dart';
import 'package:rxdart/rxdart.dart';

import '../ui/error.widget.dart' as error;

typedef Widget StreamWidgetBuilder<DATA>(DATA data);

class StreamWidget<T> extends StatelessWidget {
  final Observable<T> stream;
  final StreamWidgetBuilder<T> builder;

  ///
  /// 是否显示loading
  ///
  final bool showLoading;

  final T initData;

  ///
  /// 占位Widget是否要expand
  ///
  final isExpanded;

  const StreamWidget({
    Key key,
    @required this.stream,
    @required this.builder,
    this.showLoading = true,
    this.isExpanded = true,
    this.initData,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return StreamBuilder<T>(
      initialData: initData,
      stream: stream,
      builder: (ctx, snapshot) {
        if (snapshot.hasError) {
          return error.ErrorWidget(message: snapshot.error.toString());
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
