import 'package:flutter/material.dart';

class TestShell extends StatelessWidget {
  const TestShell({
    Key key,
    @required this.child,
  }) : super(key: key);

  final Widget child;

  @override
  Widget build(BuildContext context) {
    return MaterialApp(home: Scaffold(body: Center(child: child)));
  }
}
