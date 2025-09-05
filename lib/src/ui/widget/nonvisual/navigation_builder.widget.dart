import 'package:flutter/widgets.dart';

class NavigationBuilder extends StatefulWidget {
  final Widget Function(BuildContext context, Route? currentRoute) builder;

  const NavigationBuilder({super.key, required this.builder});

  @override
  State<NavigationBuilder> createState() => _NavigationBuilderState();
}

class _NavigationBuilderState extends State<NavigationBuilder>
    implements NavigatorObserver {
  Route? _currentRoute;
  NavigatorState? _navigator;

  @override
  void didChangeDependencies() {
    super.didChangeDependencies();
    _navigator = Navigator.maybeOf(context);
    _navigator?.widget.observers.add(this);
  }

  @override
  void dispose() {
    _navigator?.widget.observers.remove(this);
    super.dispose();
  }

  @override
  void didPush(Route route, Route? previousRoute) => _update(route);
  @override
  void didPop(Route route, Route? previousRoute) => _update(previousRoute);
  @override
  void didReplace({Route? newRoute, Route? oldRoute}) => _update(newRoute);

  @override
  void didChangeTop(Route topRoute, Route? previousTopRoute) {
    _update(topRoute);
  }

  @override
  void didRemove(Route route, Route? previousRoute) => _update(route);

  @override
  void didStartUserGesture(Route route, Route? previousRoute) {}

  @override
  void didStopUserGesture() {}

  @override
  NavigatorState? get navigator => _navigator;

  @override
  Widget build(BuildContext context) {
    return widget.builder(context, _currentRoute);
  }

  void _update(Route? route) {
    if (mounted) {
      setState(() => _currentRoute = route);
    }
  }
}
