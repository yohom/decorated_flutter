class BaseParam {
  final _param = Map<String, String>();

  ///
  /// 加入单个参数
  ///
  void putParam(String key, String value) {
    _param[key] = value;
  }

  ///
  /// 加入一组参数
  ///
  void putParamMap(Map<String, String> map) {
    _param.addAll(map);
  }

  Map<String, String> get() {
    return _param;
  }

  @override
  String toString() => _param.toString();
}
