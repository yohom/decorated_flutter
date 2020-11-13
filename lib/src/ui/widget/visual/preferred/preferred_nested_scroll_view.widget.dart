import 'package:flutter/material.dart';

class PreferredNestedScrollView extends StatelessWidget {
  const PreferredNestedScrollView({
    Key key,
    @required this.header,
    @required this.body,
  }) : super(key: key);

  final Widget header;
  final Widget body;

  @override
  Widget build(BuildContext context) {
    return NestedScrollView(
      headerSliverBuilder: (context, innerBoxIsScrolled) {
        return [SliverToBoxAdapter(child: header)];
      },
      body: body,
    );
  }
}
