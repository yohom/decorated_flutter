import 'package:flutter/material.dart';

@Deprecated('用[Visibility]代替')
class EmptyWidget extends StatelessWidget {
  const EmptyWidget({Key key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      height: 0.0,
      width: 0.0,
    );
  }
}
