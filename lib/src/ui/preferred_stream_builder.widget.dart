import 'package:flutter/material.dart';
import 'package:framework/framework.dart';
import 'package:meta/meta.dart';
import 'package:rxdart/rxdart.dart';

typedef Widget _Builder<DATA>(DATA data);

class PreferredStreamBuilder<T> extends StatelessWidget {
  static Widget defaultEmptyPlaceholder;
  static Widget defaultErrorPlaceholder;

  final Stream<T> stream;
  final _Builder<T> builder;

  /// 是否显示loading
  final bool showLoading;

  final T initialData;
  final Widget emptyPlaceholder;
  final Widget errorPlaceholder;

  static void setDefaultPlaceholder({
    Widget emptyPlaceholder,
    Widget errorPlaceholder,
  }) {
    defaultEmptyPlaceholder = emptyPlaceholder;
    defaultErrorPlaceholder = errorPlaceholder;
  }

  const PreferredStreamBuilder({
    Key key,
    @required this.stream,
    @required this.builder,
    this.showLoading = true,
    this.initialData,
    this.emptyPlaceholder,
    this.errorPlaceholder,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return StreamBuilder<T>(
      initialData: initialData,
      stream: stream,
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
        } else {
          return SizedBox.shrink();
        }
      },
    );
  }
}

@Deprecated('用DecoratedStreamBuilder代替, 只是简单的名称代替, 这个类不再维护')
class StreamWidget<T> extends StatelessWidget {
  static Widget defaultEmptyPlaceholder;
  static Widget defaultErrorPlaceholder;

  final Observable<T> stream;
  final _Builder<T> builder;

  /// 是否显示loading
  final bool showLoading;

  final T initData;
  final Widget emptyPlaceholder;
  final Widget errorPlaceholder;

  static void setDefaultPlaceholder({
    Widget emptyPlaceholder,
    Widget errorPlaceholder,
  }) {
    defaultEmptyPlaceholder = emptyPlaceholder;
    defaultErrorPlaceholder = errorPlaceholder;
  }

  const StreamWidget({
    Key key,
    @required this.stream,
    @required this.builder,
    this.showLoading = true,
    this.initData,
    this.emptyPlaceholder,
    this.errorPlaceholder,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return StreamBuilder<T>(
      initialData: initData,
      stream: stream,
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
        } else {
          return SizedBox.shrink();
        }
      },
    );
  }
}
