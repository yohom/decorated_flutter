import 'package:decorated_flutter/src/extension/extension.export.dart';
import 'package:flutter/material.dart';

class PreferredTabController extends StatelessWidget {
  const PreferredTabController({
    Key? key,
    this.onTabChanged,
    this.notifier,
    required this.length,
    required this.child,
  }) : super(key: key);

  final ValueChanged<int>? onTabChanged;
  final ValueNotifier<int>? notifier;
  final int length;
  final Widget child;

  @override
  Widget build(BuildContext context) {
    return DefaultTabController(
      length: length,
      child: _ChildWrapper(
        notifier: notifier,
        onTabChanged: onTabChanged,
        child: child,
      ),
    );
  }
}

class _ChildWrapper extends StatefulWidget {
  const _ChildWrapper({
    Key? key,
    required this.notifier,
    required this.onTabChanged,
    required this.child,
  }) : super(key: key);

  final ValueNotifier<int>? notifier;
  final ValueChanged<int>? onTabChanged;
  final Widget child;

  @override
  State<_ChildWrapper> createState() => _ChildWrapperState();
}

class _ChildWrapperState extends State<_ChildWrapper> {
  TabController? _tabController;

  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance.addPostFrameCallback((timeStamp) {
      _tabController = context.tabController;
      if (mounted) {
        _tabController!.addListener(_handleCallback);
        widget.notifier?.addListener(_handleNotify);
      }
    });
  }

  @override
  Widget build(BuildContext context) {
    return widget.child;
  }

  @override
  void dispose() {
    _tabController!.removeListener(_handleCallback);
    widget.notifier?.removeListener(_handleNotify);
    super.dispose();
  }

  void _handleNotify() {
    _tabController?.animateTo(widget.notifier!.value);
  }

  void _handleCallback() {
    if (mounted && !_tabController!.indexIsChanging) {
      widget.onTabChanged?.call(_tabController!.index);
    }
  }
}
