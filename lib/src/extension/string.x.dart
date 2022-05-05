import 'dart:convert';

import 'package:decorated_flutter/src/utils/objects.dart';

extension StringX on String {
  String plus(String addend) {
    final additionNum = num.parse(addend);
    final thisNum = num.parse(this);
    return '${additionNum + thisNum}';
  }

  bool get isMobile {
    return kMobileRegex.hasMatch(this);
  }

  bool get isNotMobile {
    return !kMobileRegex.hasMatch(this);
  }

  bool get isEmail {
    return kEmailRegex.hasMatch(this);
  }

  bool get isNotEmail {
    return kEmailRegex.hasMatch(this);
  }

  bool get isMoney {
    return kMoneyRegex.hasMatch(this);
  }

  bool get isNotMoney {
    return kMoneyRegex.hasMatch(this);
  }

  dynamic get json {
    return jsonDecode(this);
  }

  Uri? get uri {
    return Uri.tryParse(this);
  }

  int? get intValue {
    return int.tryParse(this);
  }

  double? get doubleValue {
    return double.tryParse(this);
  }

  String get packed {
    return replaceAll(RegExp(r"\s+"), '');
  }

  String substringBeforeLast(String separator) {
    final index = lastIndexOf(separator);
    return substring(0, index);
  }

  String substringAfterLast(String separator) {
    final index = lastIndexOf(separator);
    return substring(index);
  }

  String insert(int index, String divider) {
    return substring(0, index + 1) + divider + substring(index + 1);
  }

  String remove(int index) {
    return substring(0, index) + substring(index + 1);
  }

  /// 首字母大写
  String capitalize() {
    if (isEmpty) return this;
    return '${this[0].toUpperCase()}${substring(1)}';
  }

  /// 首字母小写
  String decapitalize() {
    if (isEmpty) return this;
    return '${this[0].toLowerCase()}${substring(1)}';
  }
}
