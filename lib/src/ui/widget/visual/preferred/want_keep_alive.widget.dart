import 'package:flutter/material.dart';

class WantKeepAlive extends StatefulWidget {
  const WantKeepAlive({super.key, required this.child});

  final Widget child;

  @override
  State<WantKeepAlive> createState() => _WantKeepAliveState();
}

class _WantKeepAliveState extends State<WantKeepAlive>
    with AutomaticKeepAliveClientMixin {
  @override
  bool get wantKeepAlive => true;

  @override
  Widget build(BuildContext context) {
    super.build(context);
    return widget.child;
  }
}
