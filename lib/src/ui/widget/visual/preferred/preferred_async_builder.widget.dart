import 'dart:async';

import 'package:decorated_flutter/decorated_flutter.dart';
import 'package:decorated_flutter/src/ui/widget/visual/placeholder/empty_placeholder.widget.dart';
import 'package:flutter/material.dart';

import '../placeholder/error_placeholder.widget.dart';

typedef Widget _Builder<DATA>(DATA data);
typedef Widget _ErrorPlaceholderBuilder(BuildContext context, Object error);

/// **Preferred**表达的语义是对目标widget预定义了一些参数
/// **Decorated**表达的语义是对目标widget进行了一些外围的包装
class PreferredFutureBuilder<T> extends StatelessWidget {
  static Widget defaultEmptyPlaceholder;
  static Widget defaultErrorPlaceholder;

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
    this.initialData,
    this.emptyPlaceholder,
    this.errorPlaceholderBuilder,
    this.loadingPlaceholder,
  }) : super(key: key);

  final Future<T> future;
  final _Builder<T> builder;
  final bool showLoading;
  final T initialData;
  final Widget emptyPlaceholder;
  final _ErrorPlaceholderBuilder errorPlaceholderBuilder;
  final Widget loadingPlaceholder;

  @override
  Widget build(BuildContext context) {
    return FutureBuilder<T>(
      initialData: initialData,
      future: future,
      builder: (ctx, snapshot) {
        if (snapshot.hasError) {
          L.d('PreferredFutureBuilder出现错误: ${snapshot.error}');
          if (snapshot.error is Error) {
            L.d((snapshot.error as Error).stackTrace);
          }
          if (errorPlaceholderBuilder != null) {
            return errorPlaceholderBuilder(context, snapshot.error);
          } else {
            return defaultErrorPlaceholder ?? const ErrorPlaceholder();
          }
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
          return loadingPlaceholder ?? LoadingWidget();
        } else {
          return SizedBox.shrink();
        }
      },
    );
  }
}

@Deprecated('用Subscriber代替, 只是简单的名称代替, 这个类不再维护')
class PreferredStreamBuilder<T> extends StatelessWidget {
  static Widget defaultEmptyPlaceholder;
  static Widget defaultErrorPlaceholder;

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

  @override
  Widget build(BuildContext context) {
    return StreamBuilder<T>(
      initialData: initialData,
      stream: stream,
      builder: (ctx, snapshot) {
        if (snapshot.hasError) {
          L.d('PreferredStreamBuilder出现错误: ${snapshot.error}');
          if (snapshot.error is Error) {
            L.d((snapshot.error as Error).stackTrace);
          }
          if (errorPlaceholderBuilder != null) {
            return errorPlaceholderBuilder(context, snapshot.error);
          } else {
            return defaultErrorPlaceholder ?? const ErrorPlaceholder();
          }
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
          return loadingPlaceholder ?? LoadingWidget();
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

@Deprecated('用DecoratedStreamBuilder代替, 只是简单的名称代替, 这个类不再维护')
class StreamWidget<T> extends StatelessWidget {
  static Widget defaultEmptyPlaceholder;
  static Widget defaultErrorPlaceholder;

  final Stream<T> stream;
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
