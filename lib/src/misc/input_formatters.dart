import 'package:flutter/services.dart';

// TODO 暂时没起作用 可以参考 https://stackoverflow.com/questions/58836681/how-to-make-range-number-value-on-textfield-flutter
class RangeTextInputFormatter extends TextInputFormatter {
  final num min;
  final num max;

  RangeTextInputFormatter({
    required this.min,
    required this.max,
  });

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
