import 'bloc_io/base.dart';

class PersistConfig<T> {
  /// 序列化唯一标识
  final String key;

  /// 反序列化回调
  final DeserializeCallback<T> onDeserialize;

  /// 序列化回调
  final SerializeCallback<T> onSerialize;

  /// 防抖时间间隔
  ///
  /// 可以用于在频繁写入的场景, 减少写入频率
  final Duration? debounceDuration;

  PersistConfig({
    required this.key,
    required this.onDeserialize,
    required this.onSerialize,
    @Deprecated('统一语义使用[debounceDuration]代替') Duration? debounceTime,
    Duration? debounceDuration,
  }) : debounceDuration = debounceDuration ?? debounceTime;
}
