import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:intl/intl.dart';

extension DoubleX on double {
  SizedBox get vSizeBox {
    return SizedBox(width: 0, height: this);
  }

  SizedBox get hSizeBox {
    return SizedBox(width: this, height: 0);
  }

  VerticalDivider get vDivider {
    return VerticalDivider(width: this);
  }

  Divider get hDivider {
    return Divider(height: this);
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
}
