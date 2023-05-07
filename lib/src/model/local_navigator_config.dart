// ignore_for_file: public_member_api_docs, sort_constructors_first
import 'package:flutter/widgets.dart';

class LocalNavigatorConfig {
  final RouteFactory onGenerateRoute;
  final TargetPlatform? targetPlatform;

  LocalNavigatorConfig({
    required this.onGenerateRoute,
    this.targetPlatform,
  });

  @override
  String toString() =>
      'LocalNavigatorConfig(onGenerateRoute: $onGenerateRoute, targetPlatform: $targetPlatform)';
}
