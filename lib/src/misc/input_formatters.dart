import 'package:flutter/services.dart';

class RangeTextInputFormatter extends TextInputFormatter {
  final num min;
  final num max;

  RangeTextInputFormatter({required this.min, required this.max})
    : assert(min <= max);

  @override
  TextEditingValue formatEditUpdate(
    TextEditingValue oldValue,
    TextEditingValue newValue,
  ) {
    if (!newValue.composing.isCollapsed) return newValue;
    if (newValue.text.isEmpty) return newValue;

    final newNumber = num.tryParse(newValue.text);
    if (newNumber == null || !newNumber.isFinite) return oldValue;

    if (newNumber < min || newNumber > max) {
      // shortcut: nonzero min clamps partial input, validate later for gradual entry.
      final text = newNumber.clamp(min, max).toString();
      return newValue.copyWith(
        text: text,
        selection: TextSelection.collapsed(offset: text.length),
        composing: TextRange.empty,
      );
    }

    return newValue;
  }
}

/// 仅保留已提交的汉字，允许输入法暂时保留组字内容
class ChineseTextFormatter extends TextInputFormatter {
  /// 创建汉字输入格式化器
  const ChineseTextFormatter();

  static final _chineseCharacters = RegExp(r'\p{Script=Han}', unicode: true);
  static final _filter = FilteringTextInputFormatter.allow(_chineseCharacters);

  /// 检查文本是否只含汉字，空字符串也有效
  static bool isValid(String text) {
    return text.replaceAll(_chineseCharacters, '').isEmpty;
  }

  @override
  TextEditingValue formatEditUpdate(
    TextEditingValue oldValue,
    TextEditingValue newValue,
  ) {
    if (!newValue.composing.isCollapsed) return newValue;

    return _filter.formatEditUpdate(oldValue, newValue);
  }
}
