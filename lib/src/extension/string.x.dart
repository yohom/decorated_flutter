import 'dart:convert';
import 'dart:ui';

import 'package:decorated_flutter/src/utils/objects.dart';

extension StringX on String {
  String plus(
    dynamic addend, {
    num max = double.infinity,
    num min = double.negativeInfinity,
  }) {
    final num additionNum;
    if (addend is String) {
      additionNum = num.parse(addend);
    } else if (addend is num) {
      additionNum = addend;
    } else {
      additionNum = 0;
    }
    final thisNum = num.parse(this);
    final result = additionNum + thisNum;
    return result.clamp(min, max).toString();
  }

  bool get isMobile {
    return kMobileRegex.hasMatch(this);
  }

  bool get isNotMobile {
    return !kMobileRegex.hasMatch(this);
  }

  bool get isNumber {
    return RegExp(r'^\d*$').hasMatch(this);
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
    try {
      return num.parse(this).toInt();
    } catch (e) {
      return null;
    }
  }

  double? get doubleValue {
    try {
      return double.tryParse(this);
    } catch (e) {
      return null;
    }
  }

  String get packed {
    return replaceAll(RegExp(r"\s+"), '');
  }

  String substringBeforeLast(String separator) {
    final index = lastIndexOf(separator);
    return substring(0, index);
  }

  String substringLastOf(int digit) {
    final position = length - digit;
    if (position < 0) return this;
    return substring(position);
  }

  String substringAfterLast(String separator) {
    final index = lastIndexOf(separator);
    return substring(index);
  }

  String substringBetween(String left, {required String and}) {
    final leftIndex = indexOf(left);
    final rightIndex = lastIndexOf(and);
    try {
      return substring(leftIndex + 1, rightIndex);
    } catch (e) {
      return '';
    }
  }

  String prefixWith(String str, {bool distinct = true}) {
    if (distinct && startsWith(str)) {
      return this;
    } else {
      return '$str$this';
    }
  }

  String suffixWith(String str, {bool distinct = true}) {
    if (distinct && startsWith(str)) {
      return this;
    } else {
      return '${this}$str';
    }
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

  Color toColor() {
    if (startsWith('#')) {
      return Color(int.parse(replaceAll('#', '0xff')));
    } else {
      return Color(int.parse(this));
    }
  }
}
