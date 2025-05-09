import 'dart:convert';
import 'dart:math';
import 'dart:ui';

import 'package:decorated_flutter/src/utils/logger/logger.dart';
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

  @Deprecated('使用isPhoneNumber代替, 仅仅是命名优化')
  bool get isMobile => isPhoneNumber;
  bool get isPhoneNumber => length == 11;

  @Deprecated('使用isNotPhoneNumber代替, 仅仅是命名优化')
  bool get isNotMobile => !isPhoneNumber;
  bool get isNotPhoneNumber => !isPhoneNumber;

  bool get isNumber {
    return RegExp(r'^\d+$').hasMatch(this);
  }

  bool get isPositiveNumber {
    return isNumber && (num.parse(this) > 0);
  }

  bool get isEmail {
    return isNotEmpty && kEmailRegex.hasMatch(this);
  }

  bool get isNotEmail {
    return !isEmail;
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

  List<dynamic> get jsonList {
    try {
      final json = jsonDecode(this);
      if (json is List) {
        return json;
      } else {
        return [];
      }
    } catch (_) {
      return [];
    }
  }

  Uri? get uri {
    return Uri.tryParse(this);
  }

  int? get intValue {
    try {
      return num.parse(this).toInt();
    } catch (e, s) {
      L.w('[DECORATED_FLUTTER] 字符串 $this 解析int过程出错, 要检查一下是否业务逻辑是否有问题! $s');
      return null;
    }
  }

  double? get doubleValue {
    try {
      // 某些地区的数字键盘, 小数点是逗号
      return double.tryParse(replaceAll(',', '.'));
    } catch (e, s) {
      L.w('[DECORATED_FLUTTER] 字符串 $this 解析double过程出错, 要检查一下是否业务逻辑是否有问题!, $s');
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

  String substringFirstOf(int digit) {
    final position = min(digit, length);
    return substring(0, position);
  }

  String substringAfterLast(String separator, {bool includeSeparator = false}) {
    final index = lastIndexOf(separator);
    return substring(index + (includeSeparator ? 0 : 1));
  }

  String substringBetween(String left, {required String and}) {
    final leftIndex = indexOf(left);
    final rightIndex = lastIndexOf(and);
    try {
      return substring(leftIndex + 1, rightIndex);
    } catch (e) {
      L.w('[DECORATED_FLUTTER] substringBetween过程出错, 要检查一下是否业务逻辑是否有问题!');
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
    if (distinct && endsWith(str)) {
      return this;
    } else {
      return '$this$str';
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

  /// 行数
  int get lineCount {
    return split('\n').length;
  }

  Color? toColor() {
    try {
      if (startsWith('#')) {
        return Color(int.parse(replaceAll('#', '0xff')));
      } else {
        return Color(int.parse(this));
      }
    } catch (e) {
      return null;
    }
  }

  /// 缩写化
  ///
  /// 取各个单词的首字母然后大写之
  String get abbr {
    final parts = split(' ');
    return parts.map((e) => e[0].capitalize()).join();
  }

  bool operator >(String other) {
    return compareTo(other) > 0;
  }

  bool operator >=(String other) {
    return compareTo(other) >= 0;
  }

  bool operator <(String other) {
    return compareTo(other) < 0;
  }

  bool operator <=(String other) {
    return compareTo(other) <= 0;
  }

  /// 根据codeUnit对两个字符串进行比大小
  int compareTo(String other) {
    int thisLen = length;
    int otherLen = other.length;
    int len = (thisLen < otherLen) ? thisLen : otherLen;

    for (int i = 0; i < len; i++) {
      int thisCode = codeUnitAt(i);
      int otherCode = other.codeUnitAt(i);

      if (thisCode < otherCode) {
        return -1;
      } else if (thisCode > otherCode) {
        return 1;
      }
    }

    if (thisLen < otherLen) {
      return -1;
    } else if (thisLen > otherLen) {
      return 1;
    }

    return 0;
  }
}
