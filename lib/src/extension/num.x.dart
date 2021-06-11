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

  /// 转汉字
  String toCh() {
    switch (this) {
      case 0:
        return '零';
      case 1:
        return '一';
      case 2:
        return '二';
      case 3:
        return '三';
      case 4:
        return '四';
      case 5:
        return '五';
      case 6:
        return '六';
      case 7:
        return '七';
      case 8:
        return '八';
      case 9:
        return '九';
      case 10:
        return '十';
      default:
        return '其他';
    }
  }
}
