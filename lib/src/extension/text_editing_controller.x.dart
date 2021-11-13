import 'dart:math';

import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';

extension TextEditingControllerX on TextEditingController {
  void append(String text) {
    this.text = this.text + text;
    selection =
        TextSelection.fromPosition(TextPosition(offset: this.text.length));
  }

  void backspace([int count = 1]) {
    final endIndex = max(0, text.length - count);
    text = text.substring(0, endIndex);
    selection = TextSelection.fromPosition(TextPosition(offset: text.length));
  }
}
