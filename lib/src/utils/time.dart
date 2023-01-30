import 'logger/logger.dart';

/// 前一个月
DateTime prevMonth([DateTime? date]) {
  final now = date ?? DateTime.now();
  final month = now.month - 1;
  final year = now.year;
  return DateTime(month < 1 ? year - 1 : year, month < 1 ? 12 : month);
}

/// 当前月
DateTime currentMonth([DateTime? date]) {
  final now = date ?? DateTime.now();
  return DateTime(now.year, now.month);
}

/// 下一个月
DateTime nextMonth([DateTime? date]) {
  final now = date ?? DateTime.now();
  final month = now.month + 1;
  final year = now.year;
  return DateTime(month > 12 ? year + 1 : year, month > 12 ? 1 : month);
}

/// 前一年
DateTime prevYear([DateTime? date]) {
  final now = date ?? DateTime.now();
  return DateTime(now.year - 1);
}

/// 当前年
DateTime currentYear([DateTime? date]) {
  final now = date ?? DateTime.now();
  return DateTime(now.year);
}

/// 下一年
DateTime nextYear([DateTime? date]) {
  final now = date ?? DateTime.now();
  return DateTime(now.year + 1);
}

/// 强制解析出一个日期
///
/// 如果解析出错, 就根据[fallback]逻辑构造一个代替时间
DateTime requireDate(
  String? dateString, {
  DateTime Function()? fallback,
}) {
  final now = DateTime.now();
  if (dateString == null) return now;

  DateTime date;
  try {
    final timestamp = int.tryParse(dateString);
    if (timestamp != null) {
      // 先尝试直接按毫秒解析时间戳
      date = DateTime.fromMillisecondsSinceEpoch(timestamp);
      // 如果发现年是在1970年, 则有极大概率时间戳单位是秒, 这里乘以1000再次解析
      if (date.year == 1970) {
        date = DateTime.fromMillisecondsSinceEpoch(timestamp * 1000);
      }
      return date;
    } else {
      date = DateTime.tryParse(dateString) ?? now;
      return date;
    }
  } catch (e) {
    L.w('解析日期出错($dateString), 使用当前时间代替, 错误信息: $e');
    return fallback?.call() ?? now;
  }
}
