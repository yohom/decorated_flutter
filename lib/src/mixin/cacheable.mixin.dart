mixin Cacheable {
  final _cache = <String, dynamic>{};

  void cache(String key, dynamic object) {
    _cache[key] = object;
  }

  T get<T>(String key, {T initialValue}) {
    final value = _cache[key];
    if (value != null) {
      return value;
    } else if (initialValue != null) {
      _cache[key] = initialValue;
      return initialValue;
    } else {
      return null;
    }
  }

  void evict(String key) {
    _cache.remove(key);
  }
}
