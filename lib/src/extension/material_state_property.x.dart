import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';

extension MaterialStateProperty_TextStyleX on TextStyle {
  MaterialStateProperty<TextStyle> get asMaterial {
    return MaterialStateProperty.all(this);
  }
}

extension MaterialStateProperty_ColorX on Color {
  MaterialStateProperty<Color> get asMaterial {
    return MaterialStateProperty.all(this);
  }
}
