import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';

class LoadingWidget extends StatelessWidget {
  const LoadingWidget({Key key, this.height}) : super(key: key);

  final double height;

  @override
  Widget build(BuildContext context) {
    Widget result = Center(
      child: CupertinoActivityIndicator(),
    );
    if (height != null) {
      result = SizedBox(height: height, child: result);
    }
    return result;
  }
}
