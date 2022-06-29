/// 业务异常
class BizException {
  BizException(this.code, this.message, {this.cause});

  final String code;
  final String message;
  final Object? cause;

  @override
  String toString() {
    return 'BizException{code: $code, message: $message, cause: $cause}';
  }
}
