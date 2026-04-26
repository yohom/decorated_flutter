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

  DateTimeRange asDay() {
    return DateTimeRange(
      start: DateTime(start.year, start.month, start.day),
      end: DateTime(end.year, end.month, end.day),
    );
  }

  String format({String format = 'yyyy-MM-dd HH:mm:ss', String divider = '~'}) {
    return '${start.format(format)}$divider${end.format(format)}';
  }

  DateTimeRange clamp({DateTime? lowerLimit, DateTime? upperLimit}) {
    var newStart = start;
    var newEnd = end;

    if (lowerLimit != null && newStart.isBefore(lowerLimit)) {
      newStart = lowerLimit;
    }

    if (upperLimit != null && newEnd.isAfter(upperLimit)) {
      newEnd = upperLimit;
    }

    return DateTimeRange(start: newStart, end: newEnd);
  }

  bool contains(
    DateTime time, {
    bool includeStart = true,
    bool includeEnd = false,
  }) {
    final startMillis = start.millisecondsSinceEpoch;
    final endMillis = end.millisecondsSinceEpoch;
    final timeMillis = time.millisecondsSinceEpoch;

    return (includeStart
            ? timeMillis >= startMillis
            : timeMillis > startMillis) &&
        (includeEnd ? timeMillis <= endMillis : timeMillis < endMillis);
  }
}
