import 'bloc_io/base.dart';

abstract class Persistence {
  Future<void> writeValue(String key, dynamic value);

  dynamic readValue(String key);

  void removeKey(String key);
}

class PersistConfig<T> {
  static final Set<String> _keySet = {};

  /// 序列化唯一标识
  final String key;

  /// 反序列化回调
  final DeserializeCallback<T> onDeserialize;

  /// 序列化回调
  final SerializeCallback<T> onSerialize;

  PersistConfig({
    required this.key,
    required this.onDeserialize,
    required this.onSerialize,
  }) {
    assert(!_keySet.contains(key), '和已有的持久化key重复, 请另选key!');
    _keySet.add(key);
  }
}
