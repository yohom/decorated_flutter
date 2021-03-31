import 'package:intl/intl.dart';

extension DoubleX on double {
  double asFixed(int fractionDigits) {
    return double.parse(toStringAsFixed(fractionDigits));
  }
}

extension IntX on int {
  /// 时间转为格式化字符串
  String toFormattedString(String format) {
    final dateTime = DateTime.fromMillisecondsSinceEpoch(this);
    return DateFormat(format).format(dateTime);
  }

  /// 左补齐
  String padLeft(int width, [String padding = '']) {
    return toString().padLeft(width, padding);
  }

  /// 右补齐
  String padRight(int width, [String padding = '']) {
    return toString().padRight(width, padding);
  }

  /// 重复执行任务
  void repeat(Future<void> Function() callback) async {
    for (int i = 0; i < this; i++) {
      await callback();
    }
  }
}
