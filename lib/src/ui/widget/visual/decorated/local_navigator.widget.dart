import 'package:flutter/material.dart';

class LocalNavigator extends StatelessWidget {
  const LocalNavigator({super.key, required this.builder});

  final WidgetBuilder builder;

  @override
  Widget build(BuildContext context) {
    return Theme(
      data: Theme.of(context).copyWith(platform: TargetPlatform.android),
      child: Navigator(
        onGenerateRoute: (settings) {
          return MaterialPageRoute(builder: builder);
        },
      ),
    );
  }
}
