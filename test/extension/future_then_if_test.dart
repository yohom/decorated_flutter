import 'package:decorated_flutter/src/extension/future.x.dart';
import 'package:flutter_test/flutter_test.dart';

void main() {
  test('thenIf 在 Future 成功后执行回调', () async {
    var called = false;

    final future = Future<void>.value().thenIf(true, () => called = true);

    expect(called, isFalse);
    await future;
    expect(called, isTrue);
  });

  test('thenIf 在 Future 失败时不执行回调并继续传播异常', () async {
    var called = false;

    final future = Future<void>.error('校验失败').thenIf(
      true,
      () => called = true,
    );

    await expectLater(future, throwsA('校验失败'));
    expect(called, isFalse);
  });
}
