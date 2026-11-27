import 'package:decorated_flutter/src/utils/logger/_dio_logger_filter.dart';
import 'package:dio/dio.dart';
import 'package:flutter_test/flutter_test.dart';

void main() {
  test('白名单支持通配符', () {
    final filter = DioLoggerFilter(whitelist: ['/api/users/*']);

    expect(
      filter.shouldLog(RequestOptions(path: '/api/users/profile')),
      isTrue,
    );
    expect(
      filter.shouldLog(RequestOptions(path: '/api/orders/current')),
      isFalse,
    );
  });

  test('黑名单支持通配符', () {
    final filter = DioLoggerFilter(blacklist: ['/api/users/*/heartbeat']);

    expect(
      filter.shouldLog(RequestOptions(path: '/api/users/me/heartbeat')),
      isFalse,
    );
    expect(
      filter.shouldLog(RequestOptions(path: '/api/users/me/profile')),
      isTrue,
    );
  });

  test('白名单和黑名单不能同时配置', () {
    expect(
      () => DioLoggerFilter(whitelist: [], blacklist: []),
      throwsArgumentError,
    );
  });
}
