import 'package:flutter/rendering.dart';
import 'package:flutter/widgets.dart';

/// [SliverClip] clips its sliver child from its paintOrigin to its paintExtent.
/// Also clips off any overlap if [clipOverlap] is `true`
class SliverClip extends SingleChildRenderObjectWidget {
  const SliverClip({
    super.key,
    required Widget super.child,
    this.clipOverlap = true,
    this.borderRadius = BorderRadius.zero,
    this.clipBehavior,
  });

  /// Whether or not any overlap with previous slivers should be clipped
  /// default value is `true`
  final bool clipOverlap;

  /// The border radius of the rounded corners.
  ///
  /// Defaults to [BorderRadius.zero], i.e. a rectangle with right-angled
  /// corners.
  final BorderRadiusGeometry borderRadius;

  /// {@macro flutter.rendering.ClipRectLayer.clipBehavior}
  ///
  /// If null, defaults to [Clip.hardEdge] for rectangular clips and
  /// [Clip.antiAlias] for rounded clips.
  final Clip? clipBehavior;

  @override
  _RenderSliverClip createRenderObject(BuildContext context) {
    return _RenderSliverClip(
      clipOverlap: clipOverlap,
      borderRadius: borderRadius,
      clipBehavior: clipBehavior,
      textDirection: Directionality.maybeOf(context),
    );
  }

  @override
  void updateRenderObject(
      BuildContext context, covariant _RenderSliverClip renderObject) {
    renderObject
      ..clipOverlap = clipOverlap
      ..borderRadius = borderRadius
      ..clipBehavior = clipBehavior
      ..textDirection = Directionality.maybeOf(context);
  }
}

class _RenderSliverClip extends RenderProxySliver {
  _RenderSliverClip({
    required bool clipOverlap,
    required BorderRadiusGeometry borderRadius,
    required Clip? clipBehavior,
    TextDirection? textDirection,
  })  : _clipOverlap = clipOverlap,
        _borderRadius = borderRadius,
        _clipBehavior = clipBehavior,
        _textDirection = textDirection;

  bool _clipOverlap;

  /// Whether or not any overlap with previous slivers should be clipped
  /// default value is `true`
  bool get clipOverlap => _clipOverlap;
  set clipOverlap(bool value) {
    if (_clipOverlap != value) {
      _clipOverlap = value;
      markNeedsPaint();
    }
  }

  /// The border radius of the rounded corners.
  BorderRadiusGeometry get borderRadius => _borderRadius;
  BorderRadiusGeometry _borderRadius;
  set borderRadius(BorderRadiusGeometry value) {
    if (_borderRadius != value) {
      _borderRadius = value;
      markNeedsPaint();
    }
  }

  /// The way to clip this render object's child.
  Clip? get clipBehavior => _clipBehavior;
  Clip? _clipBehavior;
  set clipBehavior(Clip? value) {
    if (_clipBehavior != value) {
      _clipBehavior = value;
      markNeedsPaint();
    }
  }

  /// The text direction with which to resolve [borderRadius].
  TextDirection? get textDirection => _textDirection;
  TextDirection? _textDirection;
  set textDirection(TextDirection? value) {
    if (_textDirection != value) {
      _textDirection = value;
      markNeedsPaint();
    }
  }

  @visibleForTesting
  Rect? get clipRect => _clipRect;
  Rect? _clipRect;

  Rect calculateClipRect() {
    final axisDirection = applyGrowthDirectionToAxisDirection(
        constraints.axisDirection, constraints.growthDirection);
    Rect rect;
    final double overlapCorrection = (clipOverlap ? constraints.overlap : 0);
    switch (axisDirection) {
      case AxisDirection.up:
        rect = Rect.fromLTWH(
          0,
          0,
          constraints.crossAxisExtent,
          geometry!.paintExtent - overlapCorrection,
        );
        break;
      case AxisDirection.right:
        rect = Rect.fromLTWH(
          geometry!.paintOrigin + overlapCorrection,
          0,
          geometry!.paintExtent - overlapCorrection,
          constraints.crossAxisExtent,
        );
        break;
      case AxisDirection.down:
        rect = Rect.fromLTWH(
          0,
          geometry!.paintOrigin + overlapCorrection,
          constraints.crossAxisExtent,
          geometry!.paintExtent - overlapCorrection,
        );
        break;
      case AxisDirection.left:
        rect = Rect.fromLTWH(
          0,
          0,
          geometry!.paintExtent - overlapCorrection,
          constraints.crossAxisExtent,
        );
        break;
    }
    return rect;
  }

  @override
  bool hitTestChildren(SliverHitTestResult result,
      {required double mainAxisPosition, required double crossAxisPosition}) {
    if (_effectiveClipBehavior(borderRadius.resolve(textDirection)) ==
        Clip.none) {
      return child != null &&
          child!.geometry!.hitTestExtent > 0 &&
          child!.hitTest(
            result,
            mainAxisPosition: mainAxisPosition,
            crossAxisPosition: crossAxisPosition,
          );
    }

    final double overlapCorrection = (clipOverlap ? constraints.overlap : 0);
    return child != null &&
        clipRect != null &&
        child!.geometry!.hitTestExtent > 0 &&
        mainAxisPosition > (geometry!.paintOrigin + overlapCorrection) &&
        mainAxisPosition <
            (geometry!.paintOrigin +
                overlapCorrection +
                (constraints.axis == Axis.vertical
                    ? clipRect!.height
                    : clipRect!.width)) &&
        child!.hitTest(
          result,
          mainAxisPosition: mainAxisPosition,
          crossAxisPosition: crossAxisPosition,
        );
  }

  @override
  void paint(PaintingContext context, Offset offset) {
    final borderRadius = this.borderRadius.resolve(textDirection);
    final clipBehavior = _effectiveClipBehavior(borderRadius);

    if (child == null || clipBehavior == Clip.none) {
      super.paint(context, offset);
      layer = null;
      return;
    }

    _clipRect = calculateClipRect();
    if (borderRadius == BorderRadius.zero) {
      layer = context.pushClipRect(
        needsCompositing,
        offset,
        clipRect!,
        super.paint,
        clipBehavior: clipBehavior,
        oldLayer: layer is ClipRectLayer ? layer as ClipRectLayer : null,
      );
    } else {
      layer = context.pushClipRRect(
        needsCompositing,
        offset,
        clipRect!,
        borderRadius.toRRect(clipRect!),
        super.paint,
        clipBehavior: clipBehavior,
        oldLayer: layer is ClipRRectLayer ? layer as ClipRRectLayer : null,
      );
    }
  }

  Clip _effectiveClipBehavior(BorderRadius borderRadius) {
    return clipBehavior ??
        (borderRadius == BorderRadius.zero ? Clip.hardEdge : Clip.antiAlias);
  }

  @override
  void debugFillProperties(DiagnosticPropertiesBuilder properties) {
    super.debugFillProperties(properties);
    properties.add(
      DiagnosticsProperty<bool>(
        'clipOverlap',
        clipOverlap,
        defaultValue: true,
      ),
    );
    properties.add(
      DiagnosticsProperty<BorderRadiusGeometry>(
        'borderRadius',
        borderRadius,
        defaultValue: BorderRadius.zero,
      ),
    );
    properties.add(
      EnumProperty<Clip?>(
        'clipBehavior',
        clipBehavior,
        defaultValue: null,
      ),
    );
  }
}
