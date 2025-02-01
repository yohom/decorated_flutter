import 'package:flutter/cupertino.dart';

extension ScrollControllerX on ScrollController {
  Future<void> animateToMax({
    Duration duration = const Duration(milliseconds: 100),
    Curve curve = Curves.decelerate,
  }) {
    if (!hasClients) return Future.value();
    return animateTo(
      positions.first.maxScrollExtent,
      duration: duration,
      curve: curve,
    );
  }

  Future<void> animateToMin({
    Duration duration = const Duration(milliseconds: 100),
    Curve curve = Curves.decelerate,
  }) {
    if (!hasClients) return Future.value();
    return animateTo(
      positions.first.minScrollExtent,
      duration: duration,
      curve: curve,
    );
  }

  Future<void> animateToNoOverscroll(
    double offset, {
    Duration duration = const Duration(milliseconds: 100),
    Curve curve = Curves.decelerate,
  }) {
    if (!hasClients) return Future.value();
    final position = positions.first;
    return animateTo(
      offset.clamp(position.minScrollExtent, position.maxScrollExtent),
      duration: duration,
      curve: curve,
    );
  }

  /// 停止滚动
  void stopScrolling() {
    if (hasClients) jumpTo(positions.first.pixels);
  }

  /// 没有overscroll效果的滚动
  Future<void> animateByNoOverscroll(
    double offset, {
    Duration duration = const Duration(milliseconds: 100),
    Curve curve = Curves.decelerate,
  }) {
    if (!hasClients) return Future.value();

    final position = positions.first;
    final targetOffset = position.pixels + offset;
    return animateTo(
      targetOffset.clamp(position.minScrollExtent, position.maxScrollExtent),
      duration: duration,
      curve: curve,
    );
  }

  /// 计算目标[context]距离视口最小值的偏移量
  Offset? offsetToStartEdge(BuildContext context) {
    if (!hasClients) return null;

    final position = positions.first;

    final renderObject = context.findRenderObject();
    if (renderObject is! RenderBox) return null;

    final globalOffset = renderObject.localToGlobal(Offset.zero);

    final scrollableBox = position.context.storageContext.findRenderObject();
    if (scrollableBox is! RenderBox) return null;

    final scrollableOffset = scrollableBox.localToGlobal(Offset.zero);

    // 计算最小偏移量：最近边缘的偏移量
    return Offset(
      globalOffset.dx - scrollableOffset.dx,
      globalOffset.dy - scrollableOffset.dy,
    );
  }

  /// 计算目标[context]距离视口最大值的偏移量
  Offset? offsetToEndEdge(BuildContext context) {
    final renderObject = context.findRenderObject();
    if (renderObject is! RenderBox) return null;

    final globalOffset = renderObject.localToGlobal(Offset.zero);
    final size = renderObject.size;

    final scrollableBox = position.context.storageContext.findRenderObject();
    if (scrollableBox is! RenderBox) return null;

    final scrollableOffset = scrollableBox.localToGlobal(Offset.zero);

    // 计算最大偏移量：最远边缘的偏移量
    final targetMaxOffsetX = globalOffset.dx + size.width;
    final targetMaxOffsetY = globalOffset.dx + size.width;
    final scrollableMaxOffsetX = scrollableOffset.dx + scrollableBox.size.width;
    final scrollableMaxOffsetY =
        scrollableOffset.dy + scrollableBox.size.height;

    return Offset(
      scrollableMaxOffsetX - targetMaxOffsetX,
      scrollableMaxOffsetY - targetMaxOffsetY,
    );
  }

  bool isInScrollRange(double offset) {
    return offset >= positions.first.minScrollExtent &&
        offset <= positions.first.maxScrollExtent;
  }

  Future<void> animateBy(
    double offset, {
    Duration duration = const Duration(milliseconds: 100),
    Curve curve = Curves.decelerate,
  }) {
    final target = position.pixels + offset;
    return animateTo(
      target,
      duration: duration,
      curve: curve,
    );
  }

  /// 滚动百分比
  double get scrollPercent {
    if (!hasClients) return 0;

    final max = positions.first.maxScrollExtent;
    if (max == 0) return 0;

    final current = positions.first.pixels;
    return current / max;
  }

  /// 距离最大值的偏移量
  double get offsetToMax {
    if (!hasClients) return 0;

    final max = positions.first.maxScrollExtent;
    if (max == 0) return 0;

    final current = positions.first.pixels;
    return max - current;
  }

  void jumpToMin() {
    if (!hasClients) return;
    return jumpTo(0);
  }

  void jumpToMax() {
    return jumpTo(position.maxScrollExtent);
  }
}
