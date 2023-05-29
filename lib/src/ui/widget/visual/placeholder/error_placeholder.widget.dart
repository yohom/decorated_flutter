import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';

class ErrorPlaceholder extends StatelessWidget {
  const ErrorPlaceholder({super.key})
      : sliver = false;

  const ErrorPlaceholder.sliver({super.key})
      : sliver = true;

  final bool sliver;

  @override
  Widget build(BuildContext context) {
    Widget result = Center(
      child: kDebugMode
          ? const Icon(Icons.error_outline, color: Colors.red)
          : Container(),
    );
    if (sliver) {
      result = SliverToBoxAdapter(child: result);
    }
    return result;
  }
}
