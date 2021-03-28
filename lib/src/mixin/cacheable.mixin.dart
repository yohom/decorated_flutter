mixin Cacheable {
  final _cache = <String, dynamic>{};

  void cache(String key, dynamic object) {
    _cache[key] = object;
  }

  void evict(String key) {
    _cache.remove(key);
  }
}
