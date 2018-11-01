import 'package:flutter/material.dart';
import 'package:framework/framework.dart';

typedef Widget _ItemBuilder<T>(BuildContext context, T data);

class FutureListView<T> extends StatelessWidget {
  const FutureListView({
    Key key,
    this.future,
    this.itemBuilder,
    this.shrinkWrap = true,
  }) : super(key: key);

  final Future<List<T>> future;
  final _ItemBuilder itemBuilder;
  final bool shrinkWrap;

  @override
  Widget build(BuildContext context) {
    return FutureWidget<List<T>>(
      future: future,
      builder: (data) {
        return ListView.builder(
          shrinkWrap: shrinkWrap,
          itemBuilder: (context, index) => itemBuilder(context, data[index]),
        );
      },
    );
  }
}
