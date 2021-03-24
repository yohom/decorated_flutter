import 'package:dio/dio.dart';
import 'package:intl/intl.dart';

extension DoubleX on double {}

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
  void repeat(VoidCallback callback) {
    for (int i = 0; i < this; i++) {
      callback();
    }
  }
}
