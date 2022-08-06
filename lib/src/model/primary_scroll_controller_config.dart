import 'package:flutter/cupertino.dart';

class PrimaryScrollControllerConfig {
  const PrimaryScrollControllerConfig({
    this.controller,
  });

  final ScrollController? controller;

  @override
  String toString() {
    return 'PrimaryScrollControllerConfig{controller: $controller}';
  }
}
