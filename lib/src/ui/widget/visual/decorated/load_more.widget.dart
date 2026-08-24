import 'dart:async';

import 'package:flutter/material.dart';

const _builtInNoMoreDataPlaceholder = Padding(
  padding: EdgeInsets.all(12),
  child: Center(child: Text('没有更多数据')),
);

typedef LoadMoreCallback = FutureOr<dynamic> Function();

class LoadMoreConfig {
  static Widget? _defaultNoMoreDataPlaceholder = _builtInNoMoreDataPlaceholder;

  static Widget? get defaultNoMoreDataPlaceholder =>
      _defaultNoMoreDataPlaceholder;

  static void setDefaultNoMoreDataPlaceholder(Widget? placeholder) {
    _defaultNoMoreDataPlaceholder = placeholder;
  }

  const LoadMoreConfig({
    required this.onLoadMore,
    this.loadMoreTriggerExtent = 200,
    this.hasMoreData = true,
    this.noMoreDataPlaceholder,
    this.showNoMoreDataPlaceholder = true,
  }) : assert(loadMoreTriggerExtent >= 0);

  /// 加载更多回调，返回[false]时表示没有更多数据。
  final LoadMoreCallback onLoadMore;

  /// 距离列表末尾小于等于此距离时触发[onLoadMore]，单位为逻辑像素。
  final double loadMoreTriggerExtent;

  /// 是否还有更多数据。
  final bool hasMoreData;

  /// 没有更多数据时展示的占位组件，null时使用全局默认值。
  final Widget? noMoreDataPlaceholder;

  /// 是否展示没有更多数据的占位组件。
  final bool showNoMoreDataPlaceholder;

  Widget? get effectiveNoMoreDataPlaceholder {
    if (!showNoMoreDataPlaceholder) return null;
    return noMoreDataPlaceholder ?? _defaultNoMoreDataPlaceholder;
  }
}

/// 为任意可滚动组件提供加载更多能力。
///
/// 使用[builder]时可以根据[hasMoreData]把没有更多占位插入到自己的列表或
/// sliver末尾；使用[child]时只提供触底回调，不自动插入占位。
class LoadMore extends StatefulWidget {
  const LoadMore({
    super.key,
    required this.config,
    this.child,
    this.builder,
    this.reverse = false,
  })  : assert(child != null || builder != null),
        assert(child == null || builder == null);

  final LoadMoreConfig config;
  final Widget? child;
  final Widget Function(BuildContext context, bool hasMoreData)? builder;
  final bool reverse;

  @override
  State<LoadMore> createState() => _LoadMoreState();
}

class _LoadMoreState extends State<LoadMore> {
  late bool _hasMoreData;
  bool _isLoadingMore = false;

  @override
  void initState() {
    super.initState();
    _hasMoreData = widget.config.hasMoreData;
  }

  @override
  void didUpdateWidget(covariant LoadMore oldWidget) {
    super.didUpdateWidget(oldWidget);
    if (oldWidget.config.hasMoreData != widget.config.hasMoreData) {
      _hasMoreData = widget.config.hasMoreData;
    }
  }

  @override
  Widget build(BuildContext context) {
    final child = widget.builder?.call(context, _hasMoreData) ?? widget.child!;
    return NotificationListener<ScrollNotification>(
      onNotification: _onScrollNotification,
      child: child,
    );
  }

  bool _onScrollNotification(ScrollNotification notification) {
    if (notification.depth != 0) return false;

    final remainingExtent = widget.reverse
        ? notification.metrics.extentBefore
        : notification.metrics.extentAfter;
    if (remainingExtent <= widget.config.loadMoreTriggerExtent) {
      _loadMore();
    }
    return false;
  }

  void _loadMore() {
    if (_isLoadingMore || !_hasMoreData) return;

    setState(() {
      _isLoadingMore = true;
    });
    _loadMoreAsync();
  }

  Future<void> _loadMoreAsync() async {
    try {
      final result = await widget.config.onLoadMore();
      if (!mounted) return;

      setState(() {
        _isLoadingMore = false;
        if (result is bool) {
          _hasMoreData = result;
        }
      });
    } catch (error, stackTrace) {
      FlutterError.reportError(
        FlutterErrorDetails(
          exception: error,
          stack: stackTrace,
          library: 'decorated_flutter',
          context: ErrorDescription('while loading more list items'),
        ),
      );
      if (mounted) {
        setState(() {
          _isLoadingMore = false;
        });
      }
    }
  }
}
