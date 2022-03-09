import 'package:decorated_flutter/decorated_flutter.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';

extension TextEditingControllerX on TextEditingController {
  void append(String appending, {bool distinct = false}) {
    if (distinct && text.endsWith(appending)) {
      L.d('要求不重复添加, 直接返回');
      return;
    }

    final beforeString = text.substring(0, selection.start);
    final afterString = text.substring(selection.end);

    text = beforeString + appending + afterString;
    selection =
        TextSelection.collapsed(offset: (beforeString + appending).length);
  }

  void backspace() {
    final beforeString = text.substring(0, selection.start);
    final afterString = text.substring(selection.end);

    // 删除前一个字符
    if (selection.isCollapsed) {
      final backspaced = beforeString.characters.skipLast(1);
      text = backspaced.string + afterString;
      selection = TextSelection.collapsed(offset: backspaced.string.length);
    }
    // 删除选中的部分
    else if (selection.isNormalized) {
      text = beforeString + afterString;
      selection = TextSelection.collapsed(offset: beforeString.length);
    }
  }
}
