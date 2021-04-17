// @dart=2.9

import 'dart:math' as math;

import 'package:flutter/material.dart';

class MaxScaleTextWidget extends StatelessWidget {
  final double max;
  final Widget child;

  const MaxScaleTextWidget({
    Key key,
    this.max = 1.0,
    @required this.child,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    var data = MediaQuery.of(context);
    var scale = math.min(max, data.textScaleFactor);
    return MediaQuery(
      data: data.copyWith(textScaleFactor: scale),
      child: child,
    );
  }
}
