// ignore_for_file: camel_case_extensions

import 'package:flutter/material.dart';

extension MaterialStateProperty_TextStyleX on TextStyle {
  WidgetStateProperty<TextStyle> get asMaterial {
    return WidgetStateProperty.all(this);
  }
}

extension MaterialStateProperty_ColorX on Color {
  WidgetStateProperty<Color> get asMaterial {
    return WidgetStateProperty.all(this);
  }
}

extension MaterialStateProperty_OutlinedBorderX on OutlinedBorder {
  WidgetStateProperty<OutlinedBorder> get asMaterial {
    return WidgetStateProperty.all(this);
  }
}

extension MaterialStateProperty_doubleX on double {
  WidgetStateProperty<double> get asMaterial {
    return WidgetStateProperty.all(this);
  }
}

extension MaterialStateProperty_intX on int {
  WidgetStateProperty<int> get asMaterial {
    return WidgetStateProperty.all(this);
  }
}

extension MaterialStateProperty_EdgeInsetsX on EdgeInsets {
  WidgetStateProperty<EdgeInsets> get asMaterial {
    return WidgetStateProperty.all(this);
  }
}

extension MaterialStateProperty_BorderSideX on BorderSide {
  WidgetStateProperty<BorderSide> get asMaterial {
    return WidgetStateProperty.all(this);
  }
}
