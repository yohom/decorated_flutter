import 'dart:async';
import 'dart:typed_data';

import 'package:decorated_flutter/src/extension/extension.export.dart';
import 'package:decorated_flutter/src/utils/utils.export.dart';
import 'package:flutter/material.dart';

class Capturer extends StatefulWidget {
  static Future<List<Uint8List>> capture(List<Widget> widgetList) {
    return _captureKey.currentState!.capture(widgetList);
  }

  static final _captureKey = GlobalKey<_CapturerState>();

  Capturer({required this.child}) : super(key: _captureKey);

  final Widget? child;

  @override
  State<Capturer> createState() => _CapturerState();
}

class _CapturerState extends State<Capturer> {
  List<(GlobalKey, Widget)> _captureLayer = [];

  @override
  Widget build(BuildContext context) {
    return Material(
      child: Stack(
        children: [
          if (_captureLayer.isNotEmpty)
            for (final item in _captureLayer)
              RepaintBoundary(key: item.$1, child: item.$2),
          if (widget.child case Widget child) child,
        ],
      ),
    );
  }

  /// 截图
  Future<List<Uint8List>> capture(List<Widget> widgetList) async {
    // 先在界面上绘制出要截图的内容
    setState(() {
      _captureLayer = [
        for (final item in widgetList) (GlobalKey(), item),
      ];
    });

    final completer = Completer<List<Uint8List>>();
    // 延迟进行截图
    Future.delayed(128.milliseconds, () {
      _captureLayer
          .map((it) => it.$1.capture())
          .wait()
          .then((value) => value.whereNotNull())
          .then(completer.complete);
      setState(doNothing);
    });

    return completer.future;
  }
}
