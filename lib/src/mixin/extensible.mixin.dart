mixin Extensible {
  Map<String, dynamic> extension = {};

  void put(String key, dynamic value) {
    extension[key] = value;
  }

  dynamic get(String key) {
    return extension[key];
  }
}
