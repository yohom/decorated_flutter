import 'package:flutter/services.dart';

// TODO 暂时没起作用 可以参考 https://stackoverflow.com/questions/58836681/how-to-make-range-number-value-on-textfield-flutter
class RangeTextInputFormatter extends TextInputFormatter {
  final num min;
  final num max;

  RangeTextInputFormatter({required this.min, required this.max});

  @override
  TextEditingValue formatEditUpdate(
    TextEditingValue oldValue,
    TextEditingValue newValue,
  ) {
    final newNumber = num.tryParse(newValue.text);
    // 如果输入的不是数字, 则返回空的字符
    if (newNumber == null) return const TextEditingValue();

    if (newNumber < min) return TextEditingValue(text: min.toString());
    if (newNumber > max) return TextEditingValue(text: max.toString());

    return oldValue;
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
