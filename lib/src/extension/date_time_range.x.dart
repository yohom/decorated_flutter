import 'package:decorated_flutter/src/extension/date_time.x.dart';
import 'package:flutter/material.dart';

extension DateTimeRangeX on DateTimeRange {
  static DateTimeRange? tryParse(String formatted, {String divider = '~'}) {
    try {
      final parts = formatted.split(divider);
      if (parts.length != 2) return null;

      return DateTimeRange(
        start: DateTime.parse(parts[0]),
        end: DateTime.parse(parts[1]),
      );
    } catch (_) {
      return null;
    }
  }

  String format({String format = 'yyyy-MM-dd HH:mm:ss', String divider = '~'}) {
    return '${start.format(format)}$divider${end.format(format)}';
  }

  bool contains(DateTime time) {
    return time.isAfter(start) && time.isBefore(end);
  }
}
