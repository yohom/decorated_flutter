import 'package:cupertino_ui/cupertino_ui.dart';

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
