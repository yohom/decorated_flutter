import 'package:kiwi/kiwi.dart';

import '../utils/utils.export.dart';

typedef FactoryCallback<T> = T Function();

final _container = KiwiContainer();

void put<T>({
  FactoryCallback<T>? factory,
  FactoryCallback<T>? singleton,
  T? instance,
  String? name,
}) {
  if (factory != null) {
    _container.registerFactory<T>((_) => factory(), name: name);
  } else if (singleton != null) {
    _container.registerSingleton<T>((_) => singleton(), name: name);
  } else if (instance != null) {
    _container.registerInstance<T>(instance, name: name);
  } else {
    throw Exception('什么对象都没有提供, put你妈?');
  }
}

/// 可选的获取对象, 返回可能为null
T? get<T>([String? name]) {
  try {
    final T result = _container.resolve(name);
    return result;
  } catch (e) {
    L.w('我警告你啊, 没找到你要的对象, 返回null了, 你看看你是不是代码逻辑有问题');
    return null;
  }
}

/// 必须的获取对象, 返回不为null
T require<T>([String? name]) {
  final T result = _container.resolve(name);
  if (result == null) throw '你他妈都没注册${T.toString()}类型的对象, 你搁这跟我要什么要对象?';
  return result;
}
