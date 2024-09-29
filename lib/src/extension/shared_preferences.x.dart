import 'dart:convert';

import 'package:decorated_flutter/decorated_flutter.dart';
import 'package:shared_preferences/shared_preferences.dart';

extension SharedPreferencesX on SharedPreferences {
  Future<bool> put(String key, dynamic value) {
    return setString(key, jsonEncode(value));
  }

  dynamic getValue(String key, {dynamic defaultValue}) {
    return getString(key)?.json ?? defaultValue;
  }

  /// 与hive保持兼容
  Future<void> delete(String key) => remove(key);
}
