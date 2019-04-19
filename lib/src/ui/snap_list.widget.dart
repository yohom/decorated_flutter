import 'package:flutter/material.dart';

class SnapList extends StatelessWidget {
  SnapList({
    Key key,
    this.initialPage = 0,
    this.aspectRatio = 1.0,
    this.viewportFraction = 1.0,
    this.padding = EdgeInsets.zero,
    @required IndexedWidgetBuilder itemBuilder,
    int itemCount,
    bool addAutomaticKeepAlive: true,
    bool addRepaintBoundaries: true,
  })  : childrenDelegate = SliverChildBuilderDelegate(
          itemBuilder,
          childCount: itemCount,
          addAutomaticKeepAlives: addAutomaticKeepAlive,
          addRepaintBoundaries: addRepaintBoundaries,
        ),
        super(key: key);

  final int initialPage;
  final double aspectRatio;
  final double viewportFraction;
  final EdgeInsetsGeometry padding;
  final SliverChildDelegate childrenDelegate;

  @override
  Widget build(BuildContext context) {
    return LayoutBuilder(
      builder: (BuildContext context, BoxConstraints constraints) {
        final itemWidth =
            (constraints.maxWidth - padding.horizontal) * viewportFraction;
        final itemHeight = itemWidth * aspectRatio;
        return Container(
          height: itemHeight,
          child: ListView.custom(
            scrollDirection: Axis.horizontal,
            controller: PageController(
              initialPage: initialPage,
              viewportFraction: viewportFraction,
            ),
            physics: const PageScrollPhysics(),
            padding: padding,
            itemExtent: itemWidth + (padding.horizontal * viewportFraction),
            childrenDelegate: childrenDelegate,
          ),
        );
      },
    );
  }
}

class FeaturedItem extends StatelessWidget {
  final String title;
  final String price;
  final VoidCallback onTap;
  final Widget child;

  FeaturedItem({
    @required this.title,
    @required this.price,
    this.onTap,
    this.child,
  });

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.all(8.0),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.stretch,
        children: <Widget>[
          Expanded(
            child: Material(
              elevation: 12.0,
              borderRadius: BorderRadius.circular(10.0),
              child: Stack(
                fit: StackFit.expand,
                children: <Widget>[
                  child,
                  Material(
                    type: MaterialType.transparency,
                    child: InkWell(onTap: onTap),
                  ),
                ],
              ),
            ),
          ),
          Padding(
            padding: const EdgeInsets.only(top: 16.0, bottom: 8.0),
            child: Text(title),
          ),
          Padding(
            padding: const EdgeInsets.only(bottom: 12.0),
            child: Text(price, style: TextStyle(fontWeight: FontWeight.bold)),
          ),
        ],
      ),
    );
  }
}
