import 'package:decorated_flutter/decorated_flutter.dart';

class BaseParam {
  final _param = Map<String, Object>();

  /// 加入单个参数
  void putParam(String key, Object value) {
    assert(isNotEmpty(key), 'key不能为null或者空字符串');
    assert(value != null, 'value不可以null, 可以为空字符串');

    _param[key] = value ?? '';
  }

  /// 加入一组参数
  void putParamMap(Map<String, Object> map) {
    assert(map != null);

    _param.addAll(map);
  }

  Map<String, Object> get() => _param;

  @override
  String toString() => _param.toString();
}
