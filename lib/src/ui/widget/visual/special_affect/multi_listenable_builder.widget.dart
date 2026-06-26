import 'package:flutter/material.dart';

/// Builder that runs every time one of the given [listenables] changes.
class MultiListenableBuilder extends StatefulWidget {
  const MultiListenableBuilder({
    super.key,
    required this.listenables,
    required this.builder,
  });

  final Set<Listenable> listenables;
  final WidgetBuilder builder;

  @override
  State createState() => _MultiListenableBuilderState();
}

class _MultiListenableBuilderState extends State<MultiListenableBuilder> {
  @override
  void initState() {
    super.initState();
    _syncListenables(oldListenables: {}, newListenables: widget.listenables);
  }

  @override
  void didUpdateWidget(MultiListenableBuilder oldWidget) {
    super.didUpdateWidget(oldWidget);
    if (widget.listenables != oldWidget.listenables) {
      _syncListenables(
        oldListenables: oldWidget.listenables,
        newListenables: widget.listenables,
      );
    }
  }

  @override
  void dispose() {
    _syncListenables(oldListenables: widget.listenables, newListenables: {});

    super.dispose();
  }

  void _syncListenables({
    required Set<Listenable> oldListenables,
    required Set<Listenable> newListenables,
  }) {
    // Remove listenables that no longer exist.
    for (final listenable in oldListenables) {
      if (!newListenables.contains(listenable)) {
        listenable.removeListener(_onListenableChange);
      }
    }

    // Add new listenables.
    for (final listenable in newListenables) {
      if (!oldListenables.contains(listenable)) {
        listenable.addListener(_onListenableChange);
      }
    }
  }

  void _onListenableChange() {
    setState(() {});
  }

  @override
  Widget build(BuildContext context) {
    return widget.builder(context);
  }
}
