import 'package:flutter/widgets.dart';

extension WidgetX on Widget {
  Text operator +(InlineSpan otherSpan) {
    final widgetSpan = WidgetSpan(child: this);
    return Text.rich(
      TextSpan(children: [widgetSpan, otherSpan]),
      softWrap: true,
      overflow: TextOverflow.ellipsis,
    );
  }

  // Future<Uint8List> capture({
  //   Duration wait,
  //   Size logicalSize,
  //   Size imageSize,
  // }) async {
  //   final RenderRepaintBoundary repaintBoundary = RenderRepaintBoundary();
  //
  //   logicalSize ??= ui.window.physicalSize / ui.window.devicePixelRatio;
  //   imageSize ??= ui.window.physicalSize;
  //
  //   assert(logicalSize.aspectRatio == imageSize.aspectRatio);
  //
  //   final RenderView renderView = RenderView(
  //     window: null,
  //     child: RenderPositionedBox(
  //       alignment: Alignment.center,
  //       child: repaintBoundary,
  //     ),
  //     configuration: ViewConfiguration(
  //       size: logicalSize,
  //       devicePixelRatio: 1.0,
  //     ),
  //   );
  //
  //   final PipelineOwner pipelineOwner = PipelineOwner();
  //   final BuildOwner buildOwner = BuildOwner();
  //
  //   pipelineOwner.rootNode = renderView;
  //   renderView.prepareInitialFrame();
  //
  //   final rootElement = RenderObjectToWidgetAdapter<RenderBox>(
  //     container: repaintBoundary,
  //     child: Directionality(
  //       textDirection: TextDirection.ltr,
  //       child: this,
  //     ),
  //   ).attachToRenderTree(buildOwner);
  //
  //   buildOwner.buildScope(rootElement);
  //
  //   if (wait != null) {
  //     await Future.delayed(wait);
  //   }
  //
  //   buildOwner.buildScope(rootElement);
  //   buildOwner.finalizeTree();
  //
  //   pipelineOwner.flushLayout();
  //   pipelineOwner.flushCompositingBits();
  //   pipelineOwner.flushPaint();
  //
  //   final ui.Image image = await repaintBoundary.toImage(
  //     pixelRatio: imageSize.width / logicalSize.width,
  //   );
  //   final byteData = await image.toByteData(format: ui.ImageByteFormat.png);
  //
  //   return byteData.buffer.asUint8List();
  // }
}
