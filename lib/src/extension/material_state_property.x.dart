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

extension MaterialStateProperty_OutlinedBorderX on OutlinedBorder {
  MaterialStateProperty<OutlinedBorder> get asMaterial {
    return MaterialStateProperty.all(this);
  }
}

extension MaterialStateProperty_doubleX on double {
  MaterialStateProperty<double> get asMaterial {
    return MaterialStateProperty.all(this);
  }
}

extension MaterialStateProperty_intX on int {
  MaterialStateProperty<int> get asMaterial {
    return MaterialStateProperty.all(this);
  }
}

extension MaterialStateProperty_EdgeInsetsX on EdgeInsets {
  MaterialStateProperty<EdgeInsets> get asMaterial {
    return MaterialStateProperty.all(this);
  }
}

extension MaterialStateProperty_BorderSideX on BorderSide {
  MaterialStateProperty<BorderSide> get asMaterial {
    return MaterialStateProperty.all(this);
  }
}
