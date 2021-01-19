import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';

extension TextEditingControllerX on TextEditingController {
  void append(String text) {
    this.text = this.text + text;
    this.selection = TextSelection.collapsed(offset: this.text.length);
  }

  void backspace([int count = 1]) {
    text = text.substring(0, text.length - 1);
    selection = TextSelection.collapsed(offset: text.length - 1);
  }
}
