mixin Extensible {
  Map<String, dynamic> _extension = {};

  void put(String key, dynamic value) {
    _extension[key] = value;
  }

  dynamic get(String key) {
    return _extension[key];
  }
}
