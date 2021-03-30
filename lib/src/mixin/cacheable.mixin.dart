mixin Cacheable {
  final _cache = <String, dynamic>{};

  void cache(String key, dynamic object) {
    _cache[key] = object;
  }

  T get<T>(String key) {
    return _cache[key];
  }

  void evict(String key) {
    _cache.remove(key);
  }
}
