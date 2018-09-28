import 'dart:math';
import 'data.dart' as data;

final _random = Random();

class Faker {
  static String city() {
    return data.city[_random.nextInt(data.city.length)];
  }

  static String name() {
    return data.name[_random.nextInt(data.name.length)];
  }

  static int time() {
    return _random.nextInt(DateTime.now().millisecondsSinceEpoch);
  }

  static int price() {
    return _random.nextInt(100000);
  }

  static int distance() {
    return _random.nextInt(100000);
  }

  static T custom<T>(List<T> data) {
    return data[_random.nextInt(data.length)];
  }
}
