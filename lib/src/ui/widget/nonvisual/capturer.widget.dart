import 'dart:async';
import 'dart:typed_data';

import 'package:decorated_flutter/decorated_flutter.dart';
import 'package:flutter/material.dart';

final _gCache = <Key, Uint8List>{};

class Capturer extends StatefulWidget {
  /// 进行截图
  ///
  /// 注意! 如果Widget传了key参数, 那么可以对其进行缓存~
  static Future<List<Uint8List>> capture(
    List<Widget> widgetList, {
    Duration? delay,
    double? pixelRatio,
  }) {
    if (_captureKey.currentState case _CapturerState state) {
      return retry(() => state.capture(
            widgetList,
            delay: delay,
            pixelRatio: pixelRatio,
          ));
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
    double? pixelRatio,
  }) async {
    // 先挑出缓存放到结果列表, 没有缓存的位置为null
    final result = [for (final item in widgetList) _gCache[item.key]];
    L.i('当前截图缓存情况: ${[
      for (final (index, item) in result.indexed)
        if (item == null) 'null' else '截图$index'
    ].join(', ')}');

    // 待截图的widget
    final pendingWidgets =
        widgetList.whereOrEmpty((it) => _gCache[it.key] == null);

    // 已经没有待截图列表了, 直接返回结果
    if (pendingWidgets.isEmpty) {
      L.i('当前没有待截图的widget, 直接返回缓存结果');
      return result.nonNulls.toList();
    }

    await waitFor(message: '截图', () => _captureLayer.isEmpty);

    // 先在界面上绘制出要截图的内容
    setState(() {
      _captureLayer = {
        for (final item in pendingWidgets) GlobalKey(): item,
      };
    });

    await Future.delayed(delay ?? const Duration(milliseconds: 64));

    // 执行截图
    final snapshots = await _captureLayer.keys
        .map((it) => it.capture(pixelRatio: pixelRatio))
        .wait()
        .then((value) => value.nonNulls.toList())
        // 完成后清空内容, 给下次截图使用
        .whenComplete(() => _captureLayer.clear());

    // 将截图结果依次插入到结果列表中null的位置
    for (final (index, item) in result.indexed) {
      if (item == null && snapshots.isNotEmpty) {
        final snapshot = snapshots.removeAt(0);
        result[index] = snapshot;

        // 加入缓存
        if (widgetList[index].key case Key key) _gCache[key] = snapshot;
      }
    }

    return result.nonNulls.toList();
  }
}
