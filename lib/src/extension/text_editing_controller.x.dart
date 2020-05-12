import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';

extension TextEditingControllerX on TextEditingController {
  void append(String text) {
    this.text = this.text + text;
    this.selection = TextSelection.collapsed(offset: this.text.length);
  }
}
