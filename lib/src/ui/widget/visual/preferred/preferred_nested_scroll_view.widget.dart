// @dart=2.9

import 'package:flutter/material.dart';

class PreferredNestedScrollView extends StatelessWidget {
  const PreferredNestedScrollView({
    Key key,
    @required this.headers,
    @required this.body,
  }) : super(key: key);

  final List<Widget> headers;
  final Widget body;

  @override
  Widget build(BuildContext context) {
    return NestedScrollView(
      headerSliverBuilder: (context, innerBoxIsScrolled) {
        return [
          for (final header in headers) SliverToBoxAdapter(child: header)
        ];
      },
      body: body,
    );
  }
}
