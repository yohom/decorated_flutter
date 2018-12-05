import 'package:decorated_flutter/framework.dart';

mixin CaptchaManagerMixin on BLoC {
  @override
  void close() {
    // 关闭全局的定时器
    CaptchaController.disposeAll();

    super.close();
  }
}
