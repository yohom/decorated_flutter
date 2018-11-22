import 'package:flutter/material.dart';

typedef Widget _Switcher(Object data);

class Switcher extends StatelessWidget {
  const Switcher({
    Key key,
    @required this.data,
    @required this.switcher,
  }) : super(key: key);

  final Object data;
  final _Switcher switcher;

  @override
  Widget build(BuildContext context) => switcher(data);
}
