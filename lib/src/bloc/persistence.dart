import 'package:decorated_flutter/decorated_flutter.dart';

@Deprecated('使用PersistConfig处理自动持久化事宜')
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

  /// 防抖时间
  ///
  /// 可以用于在频繁写入的场景, 减少写入频率
  final Duration? debounceTime;

  PersistConfig({
    required this.key,
    required this.onDeserialize,
    required this.onSerialize,
    this.debounceTime,
  }) : assert(
          !gDecoratedStorage.containsKey(key),
          '全局存储中已存在该key($key), 请检查是否代码有bug!',
        );
}
