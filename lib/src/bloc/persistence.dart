abstract class Persistence {
  Future<void> writeValue(String key, dynamic value);

  dynamic readValue(String key);

  void removeKey(String key);
}
