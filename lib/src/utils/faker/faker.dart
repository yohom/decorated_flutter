import 'dart:math';
import 'data.dart' as data;

final _random = Random();

class Faker {
  Faker._();

  static String city() {
    return data.city[_random.nextInt(data.city.length)];
  }

  static String name() {
    return data.name[_random.nextInt(data.name.length)];
  }

  /// 随机时间, 以[base]为基准, [delta]为范围进行随机
  static int time() {
    return _random.nextInt(DateTime.now().millisecondsSinceEpoch);
  }

  /// 随机价格, 以[base]为基准, [delta]为范围进行随机
  static double price({double base = 0.0, double delta = 100000.0}) {
    return base + _random.nextDouble() * delta;
  }

  /// 随机距离, 以[base]为基准, [delta]为范围进行随机
  static double distance({double base = 0.0, double delta = 100000.0}) {
    return base + _random.nextDouble() * delta;
  }

  static T custom<T>(List<T> data) {
    return data[_random.nextInt(data.length)];
  }
}
