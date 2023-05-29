import 'package:flutter/material.dart';

class SnapList extends StatelessWidget {
  SnapList({
    super.key,
    this.initialPage = 0,
    this.viewportFraction = 1.0,
    this.padding = EdgeInsets.zero,
    required IndexedWidgetBuilder itemBuilder,
    int? itemCount,
    bool addAutomaticKeepAlive = true,
    bool addRepaintBoundaries = true,
  })  : childrenDelegate = SliverChildBuilderDelegate(
          itemBuilder,
          childCount: itemCount,
          addAutomaticKeepAlives: addAutomaticKeepAlive,
          addRepaintBoundaries: addRepaintBoundaries,
        );

  final int initialPage;
  final double viewportFraction;
  final EdgeInsetsGeometry padding;
  final SliverChildDelegate childrenDelegate;

  @override
  Widget build(BuildContext context) {
    return LayoutBuilder(
      builder: (BuildContext context, BoxConstraints constraints) {
        final itemWidth =
            (constraints.maxWidth - padding.horizontal) * viewportFraction;
        return ListView.custom(
          scrollDirection: Axis.horizontal,
          controller: PageController(
            initialPage: initialPage,
            viewportFraction: viewportFraction,
          ),
          physics: const PageScrollPhysics(),
          padding: padding,
          itemExtent: itemWidth + (padding.horizontal * viewportFraction),
          childrenDelegate: childrenDelegate,
        );
      },
    );
  }
}
