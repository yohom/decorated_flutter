import 'dart:async';

import 'package:decorated_flutter/decorated_flutter.dart';
import 'package:decorated_flutter/src/ui/widget/visual/placeholder/empty_placeholder.widget.dart';
import 'package:flutter/material.dart';

import '../placeholder/error_placeholder.widget.dart';

typedef _Builder<DATA> = Widget Function(DATA data);
typedef _ErrorPlaceholderBuilder = Widget Function(
    BuildContext context, Object error);

class SingleSubscriber<T> extends StatefulWidget {
  static Widget? _defaultEmptyPlaceholder;
  static Widget? _defaultErrorPlaceholder;
  static Widget? _defaultLoadingPlaceholder;

  static void setDefaultPlaceholder({
    Widget? emptyPlaceholder,
    Widget? errorPlaceholder,
    Widget? loadingPlaceholder,
  }) {
    _defaultEmptyPlaceholder = emptyPlaceholder;
    _defaultErrorPlaceholder = errorPlaceholder;
    _defaultLoadingPlaceholder = loadingPlaceholder;
  }

  const SingleSubscriber({
    Key? key,
    required this.future,
    required this.builder,
    this.showLoading = true,
    this.initialData,
    this.cacheable = true,
    this.emptyPlaceholder,
    this.errorPlaceholderBuilder,
    this.loadingPlaceholder,
    this.handleEmpty = true,
    this.sliver = false,
    this.width,
    this.height,
    this.decoration,
  }) : super(key: key);

  /// 流
  final Future<T> future;

  /// widget builder
  final _Builder<T> builder;

  /// 是否显示loading
  final bool showLoading;

  /// 初始数据
  final T? initialData;

  /// 是否启动缓存
  final bool cacheable;

  /// 空列表视图
  final Widget? emptyPlaceholder;

  /// 错误视图
  final _ErrorPlaceholderBuilder? errorPlaceholderBuilder;

  /// loading视图
  final Widget? loadingPlaceholder;

  /// 是否处理空列表的情况
  ///
  /// 碰到EasyRefresh需要接管空列表的情况
  final bool handleEmpty;

  /// 是否使用Sliver
  final bool sliver;

  /// 宽高
  final double? width;
  final double? height;

  final Decoration? decoration;

  @override
  _SingleSubscriberState<T> createState() => _SingleSubscriberState<T>();
}

class _SingleSubscriberState<T> extends State<SingleSubscriber<T>> {
  T? _cache;

  @override
  Widget build(BuildContext context) {
    return FutureBuilder<T>(
      initialData: _cache ?? widget.initialData,
      future: widget.future,
      builder: (ctx, snapshot) {
        Widget? result;
        if (snapshot.hasError) {
          if (snapshot.error is Error) {
            L.e('SingleSubscriber出现错误: ${(snapshot.error as Error).stackTrace}');
          } else {
            L.e('SingleSubscriber出现错误: ${snapshot.error}');
          }
          if (widget.errorPlaceholderBuilder != null) {
            result ??=
                widget.errorPlaceholderBuilder!(context, snapshot.error!);
          } else {
            result ??= SingleSubscriber._defaultErrorPlaceholder ??
                ErrorPlaceholder(sliver: widget.sliver);
          }
        }

        if (snapshot.hasData) {
          if (isEmpty(snapshot.data) && widget.handleEmpty) {
            result ??= widget.emptyPlaceholder ??
                SingleSubscriber._defaultEmptyPlaceholder ??
                EmptyPlaceholder(sliver: widget.sliver);
          } else {
            if (widget.cacheable) _cache = snapshot.data;

            result ??= widget.builder(snapshot.data!);
          }
        } else if (widget.showLoading) {
          result ??= widget.loadingPlaceholder ??
              SingleSubscriber._defaultLoadingPlaceholder ??
              LoadingWidget(sliver: widget.sliver);
        } else {
          result ??= SizedBox.shrink();
        }

        if (widget.width != null ||
            widget.height != null ||
            widget.decoration != null) {
          result = Container(
            width: widget.width,
            height: widget.height,
            decoration: widget.decoration,
            child: result,
          );
        }

        return result;
      },
    );
  }
}

class Subscriber<T> extends StatelessWidget {
  static Widget? _defaultEmptyPlaceholder;
  static Widget? _defaultErrorPlaceholder;
  static Widget? _defaultLoadingPlaceholder;

  static void setDefaultPlaceholder({
    Widget? emptyPlaceholder,
    Widget? errorPlaceholder,
    Widget? loadingPlaceholder,
  }) {
    _defaultEmptyPlaceholder = emptyPlaceholder;
    _defaultErrorPlaceholder = errorPlaceholder;
    _defaultLoadingPlaceholder = loadingPlaceholder;
  }

  const Subscriber({
    Key? key,
    required this.stream,
    required this.builder,
    this.showLoading = true,
    this.initialData,
    this.emptyPlaceholder,
    this.errorPlaceholderBuilder,
    this.loadingPlaceholder,
    this.handleEmpty = true,
    this.sliver = false,
    this.width,
    this.height,
    this.decoration,
  }) : super(key: key);

  /// 流
  final Stream<T> stream;

  /// widget builder
  final _Builder<T> builder;

  /// 是否显示loading
  final bool showLoading;

  /// 初始数据
  final T? initialData;

  /// 空列表视图
  final Widget? emptyPlaceholder;

  /// 错误视图
  final _ErrorPlaceholderBuilder? errorPlaceholderBuilder;

  /// loading视图
  final Widget? loadingPlaceholder;

  /// 是否处理空列表的情况
  ///
  /// 碰到EasyRefresh需要接管空列表的情况
  final bool handleEmpty;

  /// 是否使用Sliver
  final bool sliver;

  /// 宽高
  final double? width;
  final double? height;

  final Decoration? decoration;

  @override
  Widget build(BuildContext context) {
    return StreamBuilder<T>(
      initialData: initialData,
      stream: stream,
      builder: (ctx, snapshot) {
        Widget? result;
        if (snapshot.hasError) {
          if (snapshot.error is Error) {
            L.e('Subscriber出现错误: ${(snapshot.error as Error).stackTrace}');
          } else {
            L.e('Subscriber出现错误: ${snapshot.error}');
          }
          if (errorPlaceholderBuilder != null) {
            result ??= errorPlaceholderBuilder!(context, snapshot.error!);
          } else {
            result ??=
                _defaultErrorPlaceholder ?? ErrorPlaceholder(sliver: sliver);
          }
        }

        if (snapshot.hasData) {
          if (isEmpty(snapshot.data) && handleEmpty) {
            result ??= emptyPlaceholder ??
                _defaultEmptyPlaceholder ??
                EmptyPlaceholder(sliver: sliver);
          } else {
            result ??= builder(snapshot.data!);
          }
        } else if (showLoading) {
          result ??= loadingPlaceholder ??
              _defaultLoadingPlaceholder ??
              LoadingWidget(sliver: sliver);
        } else {
          result ??= SizedBox.shrink();
        }

        if (width != null || height != null || decoration != null) {
          result = Container(
            width: width,
            height: height,
            decoration: decoration,
            child: result,
          );
        }

        return result;
      },
    );
  }
}
