import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';

class ErrorPlaceholder extends StatelessWidget {
  const ErrorPlaceholder({Key? key})
      : sliver = false,
        super(key: key);

  const ErrorPlaceholder.sliver({Key? key})
      : sliver = true,
        super(key: key);

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
