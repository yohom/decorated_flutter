import 'dart:async';

import 'package:decorated_flutter/decorated_flutter.dart';
import 'package:flutter/material.dart';

typedef Widget _ItemBuilder<T>(BuildContext context, T data);
typedef Widget _ErrorPlaceholderBuilder(BuildContext context, Object error);
typedef bool _Filter<T>(T element);

class FutureListView<T> extends StatelessWidget {
  const FutureListView({
    Key key,
    @required this.future,
    @required this.itemBuilder,
    this.shrinkWrap = true,
    this.showLoading = true,
    this.initialData,
    this.emptyPlaceholder,
    this.loadingPlaceholder,
    this.errorPlaceholderBuilder,
    this.padding,
    this.physics = const ClampingScrollPhysics(),
    this.reverse = false,
    this.divider,
    this.startWithDivider = false,
    this.endWithDivider = false,
    this.where,
  }) : super(key: key);

  //region FutureWidget
  final Future<List<T>> future;
  final bool showLoading;
  final List<T> initialData;
  final Widget emptyPlaceholder;
  final Widget loadingPlaceholder;
  final _ErrorPlaceholderBuilder errorPlaceholderBuilder;

  //endregion
  //region ListView.builder
  final _ItemBuilder<T> itemBuilder;
  final bool shrinkWrap;
  final EdgeInsets padding;
  final ScrollPhysics physics;
  final bool reverse;

  //endregion
  final Widget divider;
  final bool startWithDivider;
  final bool endWithDivider;
  final _Filter<T> where;

  @override
  Widget build(BuildContext context) {
    return PreferredFutureBuilder<List<T>>(
      future: future,
      showLoading: showLoading,
      initialData: initialData,
      emptyPlaceholder: emptyPlaceholder,
      loadingPlaceholder: loadingPlaceholder,
      errorPlaceholderBuilder: errorPlaceholderBuilder,
      builder: (data) {
        List<T> filteredData = data;
        if (where != null) {
          filteredData = data.where(where).toList();
        }
        return ListView.builder(
          padding: padding,
          shrinkWrap: shrinkWrap,
          physics: physics,
          reverse: reverse,
          itemCount: filteredData.length ?? 0,
          itemBuilder: (context, index) {
            return _buildItem(
              context,
              filteredData,
              index,
              reverse,
              startWithDivider,
              endWithDivider,
              divider,
              itemBuilder,
            );
          },
        );
      },
    );
  }
}

class StreamListView<T> extends StatelessWidget {
  StreamListView({
    Key key,
    this.stream,
    this.incrementalStream,
    @required this.itemBuilder,
    this.shrinkWrap = true,
    this.showLoading = true,
    this.initialData,
    this.emptyPlaceholder,
    this.loadingPlaceholder,
    this.errorPlaceholderBuilder,
    this.padding,
    this.physics = const ClampingScrollPhysics(),
    this.reverse = false,
    this.divider,
    this.onRefresh,
    this.onLoadMore,
    ScrollController controller,
    this.refreshDisplacement = 40.0,
    this.refreshColor,
    this.refreshBackgroundColor,
    this.notificationPredicate = defaultScrollNotificationPredicate,
    this.where,
    this.incremental = false,
    this.distinct = false,
    this.startWithDivider = false,
    this.endWithDivider = false,
    this.insertFromHead = false,
  })  : _controller = controller ?? ScrollController(),
        // 如果是增量, 那么incrementalStream必须不为空且stream必须为空; 反之只能设置stream不为空
        assert((incremental && incrementalStream != null && stream == null) ||
            (!incremental && stream != null && incrementalStream == null)),
        super(key: key) {
    _controller?.addListener(() {
      if (_controller.position.maxScrollExtent == _controller.offset) {
        if (onLoadMore != null && !_inLoading.value) {
          _inLoading.value = true;
          onLoadMore().whenComplete(() {
            L.p('加载更多完成');
            _inLoading.value = false;
          });
        }
      }
    });
  }

  //region FutureWidget
  final Stream<List<T>> stream;
  final Stream<T> incrementalStream;
  final bool showLoading;
  final List<T> initialData;
  final Widget emptyPlaceholder;
  final Widget loadingPlaceholder;
  final _ErrorPlaceholderBuilder errorPlaceholderBuilder;

  //endregion
  //region ListView.builder
  final _ItemBuilder<T> itemBuilder;
  final bool shrinkWrap;
  final EdgeInsets padding;
  final ScrollPhysics physics;
  final bool reverse;

  //endregion
  //region RefreshIndicator
  final RefreshCallback onRefresh;
  final RefreshCallback onLoadMore;
  final ScrollController _controller;
  final double refreshDisplacement;
  final Color refreshColor;
  final Color refreshBackgroundColor;
  final ScrollNotificationPredicate notificationPredicate;

  //endregion
  final Widget divider;

  /// 过滤器
  final _Filter<T> where;

  /// 是否增量刷新
  final bool incremental;

  /// 元素是否唯一
  final bool distinct;

  /// 头部插入divider
  final bool startWithDivider;

  /// 尾部插入divider
  final bool endWithDivider;

  /// 从开头插入
  final bool insertFromHead;

  final _cachedList = <T>[];
  final _inLoading = Value(false);

  @override
  Widget build(BuildContext context) {
    Widget result = PreferredStreamBuilder<List<T>>(
      stream: incremental ? incrementalStream.map((it) => [it]) : stream,
      showLoading: showLoading,
      initialData: initialData,
      emptyPlaceholder: emptyPlaceholder,
      loadingPlaceholder: loadingPlaceholder,
      errorPlaceholderBuilder: errorPlaceholderBuilder,
      builder: (data) {
        List<T> filteredData = _cachedList;
        if (incremental) {
          if (insertFromHead) {
            filteredData.insertAll(0, data);
          } else {
            filteredData.addAll(data);
          }
        } else {
          filteredData = data;
        }

        if (where != null) {
          filteredData = filteredData.where(where).toList();
        }

        if (distinct) {
          filteredData = filteredData.toSet().toList();
        }

        return ListView.builder(
          padding: padding,
          shrinkWrap: shrinkWrap,
          physics: physics,
          reverse: reverse,
          controller: _controller,
          itemCount: filteredData.length ?? 0,
          itemBuilder: (context, index) {
            return _buildItem(
              context,
              filteredData,
              index,
              reverse,
              startWithDivider,
              endWithDivider,
              divider,
              itemBuilder,
            );
          },
        );
      },
    );

    if (onRefresh != null) {
      result = RefreshIndicator(
        child: result,
        onRefresh: () {
          _cachedList.clear();
          return onRefresh();
        },
        displacement: refreshDisplacement,
        color: refreshColor,
        backgroundColor: refreshBackgroundColor,
        notificationPredicate: notificationPredicate,
      );
    }
    return result;
  }
}

Widget _buildItem<T>(
  BuildContext context,
  List<T> filteredData,
  int index,
  bool reverse,
  bool startWithDivider,
  bool endWithDivider,
  Widget divider,
  _ItemBuilder<T> itemBuilder,
) {
  final data = filteredData[index];
  if (divider == null) {
    return itemBuilder(context, data);
  } else if (startWithDivider && index == 0) {
    return Column(
      children: <Widget>[
        divider,
        itemBuilder(context, data),
        divider,
      ],
    );
  } else if (endWithDivider) {
    if (reverse) {
      return Column(
        children: <Widget>[
          divider,
          itemBuilder(context, data),
        ],
      );
    } else {
      return Column(
        children: <Widget>[
          itemBuilder(context, data),
          divider,
        ],
      );
    }
  } else {
    if (index < filteredData.length - 1) {
      if (reverse) {
        return Column(
          children: <Widget>[
            divider,
            itemBuilder(context, data),
          ],
        );
      } else {
        return Column(
          children: <Widget>[
            itemBuilder(context, data),
            divider,
          ],
        );
      }
    } else {
      return itemBuilder(context, data);
    }
  }
}
