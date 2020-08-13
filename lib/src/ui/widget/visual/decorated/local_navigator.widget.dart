import 'package:flutter/material.dart';

class LocalNavigator extends StatelessWidget {
  const LocalNavigator({Key key, this.child}) : super(key: key);

  final Widget child;

  @override
  Widget build(BuildContext context) {
    return Theme(
      data: Theme.of(context).copyWith(platform: TargetPlatform.android),
      child: Navigator(
        onGenerateRoute: (settings) {
          return MaterialPageRoute(builder: (context) => child);
        },
      ),
    );
  }
}
