import 'package:flutter/material.dart';
import 'package:decorated_flutter/decorated_flutter.dart';

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
    this.errorPlaceholderBuilder,
    this.padding,
    this.physics = const ClampingScrollPhysics(),
    this.divider,
    this.where,
  }) : super(key: key);

  //region FutureWidget
  final Future<List<T>> future;
  final bool showLoading;
  final List<T> initialData;
  final Widget emptyPlaceholder;
  final _ErrorPlaceholderBuilder errorPlaceholderBuilder;

  //endregion
  //region ListView.builder
  final _ItemBuilder<T> itemBuilder;
  final bool shrinkWrap;
  final EdgeInsets padding;
  final ScrollPhysics physics;

  //endregion
  final Widget divider;
  final _Filter<T> where;

  @override
  Widget build(BuildContext context) {
    return PreferredFutureBuilder<List<T>>(
      future: future,
      showLoading: showLoading,
      initialData: initialData,
      emptyPlaceholder: emptyPlaceholder,
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
          itemCount: filteredData.length ?? 0,
          itemBuilder: (context, index) {
            if (index != filteredData.length - 1 && divider != null) {
              return Column(
                children: <Widget>[
                  itemBuilder(context, filteredData[index]),
                  divider,
                ],
              );
            } else {
              return itemBuilder(context, filteredData[index]);
            }
          },
        );
      },
    );
  }
}

class StreamListView<T> extends StatelessWidget {
  const StreamListView({
    Key key,
    @required this.stream,
    @required this.itemBuilder,
    this.shrinkWrap = true,
    this.showLoading = true,
    this.initialData,
    this.emptyPlaceholder,
    this.errorPlaceholderBuilder,
    this.padding,
    this.physics = const ClampingScrollPhysics(),
    this.divider,
    this.onRefresh,
    this.refreshDisplacement = 40.0,
    this.refreshColor,
    this.refreshBackgroundColor,
    this.notificationPredicate = defaultScrollNotificationPredicate,
    this.where,
  }) : super(key: key);

  //region FutureWidget
  final Stream<List<T>> stream;
  final bool showLoading;
  final List<T> initialData;
  final Widget emptyPlaceholder;
  final _ErrorPlaceholderBuilder errorPlaceholderBuilder;

  //endregion
  //region ListView.builder
  final _ItemBuilder<T> itemBuilder;
  final bool shrinkWrap;
  final EdgeInsets padding;
  final ScrollPhysics physics;

  //endregion
  //region RefreshIndicator
  final RefreshCallback onRefresh;
  final double refreshDisplacement;
  final Color refreshColor;
  final Color refreshBackgroundColor;
  final ScrollNotificationPredicate notificationPredicate;

  //endregion
  final Widget divider;
  final _Filter<T> where;

  @override
  Widget build(BuildContext context) {
    Widget result = PreferredStreamBuilder<List<T>>(
      stream: stream,
      showLoading: showLoading,
      initialData: initialData,
      emptyPlaceholder: emptyPlaceholder,
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
          itemCount: filteredData.length ?? 0,
          itemBuilder: (context, index) {
            if (index != filteredData.length - 1 && divider != null) {
              return Column(
                children: <Widget>[
                  itemBuilder(context, filteredData[index]),
                  divider,
                ],
              );
            } else {
              return itemBuilder(context, filteredData[index]);
            }
          },
        );
      },
    );

    if (onRefresh != null) {
      result = RefreshIndicator(
        child: result,
        onRefresh: onRefresh,
        displacement: refreshDisplacement,
        color: refreshColor,
        backgroundColor: refreshBackgroundColor,
        notificationPredicate: notificationPredicate,
      );
    }
    return result;
  }
}
