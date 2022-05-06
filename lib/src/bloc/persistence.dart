import 'bloc_io/base.dart';

abstract class Persistence {
  Future<void> writeValue(String key, dynamic value);

  dynamic readValue(String key);

  void removeKey(String key);
}

class PersistConfig<T> {
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
  });
}
