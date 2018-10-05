import 'package:flutter/material.dart';
import 'package:framework/framework.dart';
import 'package:meta/meta.dart';
import 'package:rxdart/rxdart.dart';

typedef Widget _StreamWidgetBuilder<DATA>(DATA data);

class StreamWidget<T> extends StatelessWidget {
  final Observable<T> stream;
  final _StreamWidgetBuilder<T> builder;

  /// 是否显示loading
  final bool showLoading;

  final T initData;
  final Widget emptyWidget;
  final Widget errorWidget;

  const StreamWidget({
    Key key,
    @required this.stream,
    @required this.builder,
    this.showLoading = true,
    this.initData,
    this.emptyWidget,
    this.errorWidget,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return StreamBuilder<T>(
      initialData: initData,
      stream: stream,
      builder: (ctx, snapshot) {
        if (snapshot.hasError) {
          return errorWidget ?? ErrorWidget(snapshot.error.toString());
        }

        if (snapshot.hasData) {
          return builder(snapshot.data);
        } else if (showLoading) {
          return LoadingWidget();
        } else {
          return emptyWidget ?? EmptyWidget();
        }
      },
    );
  }
}
