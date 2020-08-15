import 'package:decorated_flutter/decorated_flutter.dart';

mixin CaptchaManagerMixin on BLoC {
  @override
  void dispose() {
    // 关闭全局的定时器
    CaptchaController.disposeAll();

    super.dispose();
  }
}
