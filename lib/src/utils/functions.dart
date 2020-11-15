import 'package:decorated_flutter/decorated_flutter.dart';

final notEqual = (prev, next) => prev != next;
final notNull = (data) => data != null;
final notEmpty = (data) => isNotEmpty(data);
final isTrue = (bool data) => data == true;
final isFalse = (bool data) => data == false;
