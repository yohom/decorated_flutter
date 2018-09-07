import 'package:flutter_test/flutter_test.dart';
import 'package:mockito/mockito.dart';
import 'package:framework/framework.dart';

void main() {
  BaseParam param;

  setUp(() {
    param = BaseParam();
  });

  group('BaseParam.putParam', () {
    test('加入一对非空参数 ===> `param.get()`增加一个MapEntry', () {
      param.putParam('key1', 'value1');
      param.putParam('key2', 'value2');

      expect(param.get(), {'key1': 'value1', 'key2': 'value2'});
    });

    test('加入null的key, any的value ==> 触发assert', () {
      expect(() => param.putParam(null, any), throwsAssertionError);
    });

    test('加入空字符串的key, any的value ==> 触发assert', () {
      expect(() => param.putParam('', any), throwsAssertionError);
    });

    group('加入非空字符串的key', () {
      test('null的value ==> 触发assert', () {
        expect(() => param.putParam('key', null), throwsAssertionError);
      });

      test('空字符串的value ==> 正常返回', () {
        expect(() => param.putParam('key', ''), returnsNormally);
      });

      test('非空字符串的value ==> 正常返回', () {
        expect(() => param.putParam('key', ''), returnsNormally);
      });
    });
  });

  group('BaseParam.putParamMap', () {
    test('加入一个非空Map ==> `param.get()`对应增加一个Map', () {
      param.putParamMap({'key3': 'value3', 'key4': 'value4'});

      expect(param.get(), {'key3': 'value3', 'key4': 'value4'});
    });

    test('加入一个null ==> 触发assert', () {
      expect(() => param.putParamMap(null), throwsAssertionError);
    });
  });
}
