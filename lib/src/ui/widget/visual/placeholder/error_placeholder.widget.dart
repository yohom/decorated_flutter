import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';

class ErrorPlaceholder extends StatelessWidget {
  const ErrorPlaceholder({
    super.key,
    this.error,
    this.stackTrace,
  }) : sliver = false;

  const ErrorPlaceholder.sliver({
    super.key,
    this.error,
    this.stackTrace,
  }) : sliver = true;

  final bool sliver;
  final Object? error;
  final StackTrace? stackTrace;

  @override
  Widget build(BuildContext context) {
    Widget result = Center(
      child: kDebugMode
          ? IconButton(
              visualDensity: VisualDensity.compact,
              onPressed: () => showDialog(
                context: context,
                builder: (context) => AlertDialog(
                  title: Text(error?.toString() ?? '暂无错误信息'),
                  content: Text(stackTrace?.toString() ?? '暂无错误信息'),
                ),
              ),
              icon: const Icon(Icons.error_outline, color: Colors.red),
            )
          : Container(),
    );
    if (sliver) {
      result = SliverToBoxAdapter(child: result);
    }
    return result;
  }
}
