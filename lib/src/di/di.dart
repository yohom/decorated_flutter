import 'package:kiwi/kiwi.dart';

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
    throw Exception('什么对象都没有提供, 您图啥?');
  }
}

T get<T>([String? name]) {
  return _container.resolve(name);
}
