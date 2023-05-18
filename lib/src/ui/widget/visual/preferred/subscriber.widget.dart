import 'dart:async';

import 'package:decorated_flutter/decorated_flutter.dart';
import 'package:flutter/material.dart';

typedef _Builder<DATA> = Widget Function(DATA data);
typedef _ErrorPlaceholderBuilder = Widget Function(
  BuildContext context,
  Object error,
);

class SliverConfig {
  const SliverConfig({
    this.error = true,
    this.empty = true,
    this.loading = true,
    this.data = true,
    this.padding,
  });

  const SliverConfig.placeholder({this.padding})
      : error = true,
        empty = true,
        loading = true,
        data = false;

  final bool error;
  final bool empty;
  final bool loading;
  final bool data;
  final EdgeInsets? padding;

  @override
  String toString() {
    return 'SliverConfig{error: $error, empty: $empty, loading: $loading, data: $data}';
  }
}

class AnimationConfig {
  final Duration duration;
  final Curve curve;
  final Alignment alignment;

  const AnimationConfig({
    this.duration = const Duration(milliseconds: 500),
    this.curve = Curves.decelerate,
    this.alignment = Alignment.topLeft,
  });

  @override
  String toString() {
    return 'AnimationConfig{duration: $duration, curve: $curve, alignment: $alignment}';
  }
}

enum SnapshotType {
  error,
  empty,
  loading,
  data,
  unknown,
}

class SingleSubscriber<T> extends StatefulWidget {
  static Widget? _defaultEmptyPlaceholder;
  static _ErrorPlaceholderBuilder? _defaultErrorPlaceholder;
  static Widget? _defaultLoadingPlaceholder;

  static void setDefaultPlaceholder({
    Widget? emptyPlaceholder,
    _ErrorPlaceholderBuilder? errorPlaceholder,
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
          L.e('Subscriber出现错误: ${snapshot.error}, 调用栈:\n ${snapshot.stackTrace}');
          if (widget.errorPlaceholderBuilder != null) {
            result ??=
                widget.errorPlaceholderBuilder!(context, snapshot.error!);
          } else {
            result ??= SingleSubscriber._defaultErrorPlaceholder
                    ?.call(context, snapshot.error!) ??
                const ErrorPlaceholder();
          }
        }

        if (snapshot.hasData) {
          if (isEmpty(snapshot.data) && widget.handleEmpty) {
            result ??= widget.emptyPlaceholder ??
                SingleSubscriber._defaultEmptyPlaceholder ??
                const EmptyPlaceholder();
          } else {
            if (widget.cacheable) _cache = snapshot.data;

            result ??= widget.builder(snapshot.data as T);
          }
        } else if (widget.showLoading) {
          result ??= widget.loadingPlaceholder ??
              SingleSubscriber._defaultLoadingPlaceholder ??
              const LoadingWidget();
        } else {
          result ??= (SPACE_ZERO);
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

        if (widget.sliver) result = SliverToBoxAdapter(child: result);
        return result;
      },
    );
  }
}

class Subscriber<T> extends StatelessWidget {
  static Widget? _defaultEmptyPlaceholder;
  static _ErrorPlaceholderBuilder? _defaultErrorPlaceholder;
  static Widget? _defaultLoadingPlaceholder;

  static void setDefaultPlaceholder({
    Widget? emptyPlaceholder,
    _ErrorPlaceholderBuilder? errorPlaceholder,
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
    this.sliver,
    this.width,
    this.height,
    this.aspectRatio,
    this.decoration,
    this.onErrorTapped,
    this.onEmptyTapped,
    this.animationConfig,
    this.padding,
    this.margin,
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
  final SliverConfig? sliver;

  /// 宽高
  final double? width, height, aspectRatio;

  /// 默认错误Widget被点击
  final ValueChanged<dynamic>? onErrorTapped;

  /// 默认空Widget被点击
  final VoidCallback? onEmptyTapped;

  final Decoration? decoration;

  final AnimationConfig? animationConfig;

  final EdgeInsets? padding, margin;

  @override
  Widget build(BuildContext context) {
    return StreamBuilder<T>(
      initialData: initialData,
      stream: stream,
      builder: (ctx, snapshot) {
        SnapshotType snapshotType;
        Widget? result;
        if (snapshot.hasError) {
          final error = snapshot.error!;
          L.e('Subscriber出现错误: $error, 调用栈:\n ${snapshot.stackTrace}');
          if (errorPlaceholderBuilder != null) {
            result ??= errorPlaceholderBuilder!(context, error);
          } else {
            result ??= (_defaultErrorPlaceholder?.call(context, error) ??
                const ErrorPlaceholder());
          }

          if (onErrorTapped != null) {
            result = GestureDetector(
              onTap: () => onErrorTapped!(error),
              child: result,
            );
          }

          snapshotType = SnapshotType.error;
        }

        if (snapshot.hasData) {
          if (isEmpty(snapshot.data) && handleEmpty) {
            result ??= emptyPlaceholder ??
                _defaultEmptyPlaceholder ??
                const EmptyPlaceholder();

            if (onEmptyTapped != null) {
              result = GestureDetector(onTap: onEmptyTapped, child: result);
            }

            snapshotType = SnapshotType.empty;
          } else {
            result ??= builder(snapshot.data as T);

            snapshotType = SnapshotType.data;
          }
        } else if (showLoading) {
          result ??= loadingPlaceholder ??
              _defaultLoadingPlaceholder ??
              const LoadingWidget();

          snapshotType = SnapshotType.loading;
        } else {
          result ??= SPACE_ZERO;

          snapshotType = SnapshotType.unknown;
        }

        if (width != null || height != null || decoration != null) {
          result = Container(
            width: width,
            height: height,
            decoration: decoration,
            padding: padding,
            margin: margin,
            child: result,
          );
        }

        if (aspectRatio != null) {
          result = AspectRatio(aspectRatio: aspectRatio!, child: result);
        }

        if (animationConfig != null) {
          result = AnimatedSize(
            duration: animationConfig!.duration,
            curve: animationConfig!.curve,
            alignment: animationConfig!.alignment,
            child: result,
          );
        }

        if (sliver != null) {
          switch (snapshotType) {
            case SnapshotType.error:
              if (sliver!.error) result = SliverToBoxAdapter(child: result);
              break;
            case SnapshotType.empty:
              if (sliver!.empty) result = SliverToBoxAdapter(child: result);
              break;
            case SnapshotType.data:
              if (sliver!.data) result = SliverToBoxAdapter(child: result);
              break;
            case SnapshotType.loading:
              if (sliver!.loading) result = SliverToBoxAdapter(child: result);
              break;
            default:
              result = SliverToBoxAdapter(child: result);
              break;
          }

          if (sliver!.padding != null) {
            result = SliverPadding(padding: sliver!.padding!, sliver: result);
          }
        }

        return result;
      },
    );
  }
}
