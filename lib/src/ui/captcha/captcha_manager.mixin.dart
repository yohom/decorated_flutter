import 'package:framework/framework.dart';

class CaptchaManagerMixin extends BLoC {
  @override
  void close() {
    // 关闭全局的定时器
    CaptchaController.disposeAll();

    super.close();
  }
}
