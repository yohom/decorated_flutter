mixin Extensible {
  Map<dynamic, dynamic> extension = {};

  void put(dynamic key, dynamic value) {
    extension[key] = value;
  }

  dynamic get(dynamic key) {
    return extension[key];
  }
}
