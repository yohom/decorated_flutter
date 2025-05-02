import 'dart:async';
import 'dart:typed_data';

import 'package:decorated_flutter/decorated_flutter.dart';
import 'package:flutter/material.dart';

class Capturer extends StatefulWidget {
  static Future<List<Uint8List>> capture(
    List<Widget> widgetList, {
    Duration? delay,
  }) {
    if (_captureKey.currentState case _CapturerState state) {
      return retry(() => state.capture(widgetList, delay: delay));
    } else {
      return Future.error(
        '未找到Capturer实例, 是否已经在DecoratedApp设置withCapturer为true? 或者在全局嵌套Capturer?',
      );
    }
  }

  static final _captureKey = GlobalKey<_CapturerState>();

  Capturer({required this.child}) : super(key: _captureKey);

  final Widget? child;

  @override
  State<Capturer> createState() => _CapturerState();
}

class _CapturerState extends State<Capturer> {
  Map<GlobalKey, Widget> _captureLayer = {};

  @override
  Widget build(BuildContext context) {
    return Material(
      child: Stack(
        children: [
          if (_captureLayer.isNotEmpty)
            for (final item in _captureLayer.entries)
              RepaintBoundary(key: item.key, child: item.value),
          if (widget.child case Widget child) child,
        ],
      ),
    );
  }

  /// 截图
  Future<List<Uint8List>> capture(
    List<Widget> widgetList, {
    Duration? delay,
  }) async {
    await waitFor(message: '截图', () => _captureLayer.isEmpty);

    // 先在界面上绘制出要截图的内容
    setState(() {
      _captureLayer = {
        for (final item in widgetList) GlobalKey(): item,
      };
    });

    await Future.delayed(delay ?? const Duration(milliseconds: 64));
    return _captureLayer.keys
        .map((it) => it.capture())
        .wait()
        .then((value) => value.whereNotNull())
        // 完成后清空内容, 给下次截图使用
        .whenComplete(() => _captureLayer.clear());
  }
}
