import 'package:flutter/material.dart';

class PreferredNestedScrollView extends StatelessWidget {
  const PreferredNestedScrollView({
    super.key,
    required this.headers,
    required this.body,
    this.physics,
  });

  final List<Widget> headers;
  final Widget body;
  final ScrollPhysics? physics;

  @override
  Widget build(BuildContext context) {
    return NestedScrollView(
      physics: physics,
      headerSliverBuilder: (context, innerBoxIsScrolled) {
        return [
          for (final header in headers) SliverToBoxAdapter(child: header)
        ];
      },
      body: body,
    );
  }
}
