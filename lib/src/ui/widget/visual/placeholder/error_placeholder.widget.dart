import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';

class ErrorPlaceholder extends StatelessWidget {
  const ErrorPlaceholder({
    Key? key,
    this.sliver = false,
  }) : super(key: key);

  final bool sliver;

  @override
  Widget build(BuildContext context) {
    Widget result = Center(
      child: kDebugMode
          ? Icon(Icons.error_outline, color: Colors.red)
          : Container(),
    );
    if (sliver) {
      result = SliverToBoxAdapter(child: result);
    }
    return result;
  }
}
