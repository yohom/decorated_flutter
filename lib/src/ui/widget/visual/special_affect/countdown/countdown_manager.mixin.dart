import 'package:decorated_flutter/decorated_flutter.dart';

mixin CountdownManagerMixin on BLoC {
  @override
  void close() {
    // 关闭全局的定时器
    CountdownController.disposeAll();

    super.close();
  }
}
