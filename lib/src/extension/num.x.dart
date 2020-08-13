import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';

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
