import 'dart:async';

import 'package:flutter/material.dart';

/// Hero 弹窗共享元素飞行内容的构造器。
typedef HeroDialogFlightBuilder = Widget Function(
  BuildContext context,
  Widget child,
);

/// 为 [OverlayHero] 提供配对范围。
///
/// 将源内容与 [showHeroOverlay] 的调用点置于同一个 Scope 中；弹窗内容会
/// 自动复用该 Scope，因此拥有相同 [OverlayHero.tag] 的组件会执行共享元素飞行。
class HeroDialogScope extends StatefulWidget {
  /// 创建 Hero 弹窗共享元素范围。
  const HeroDialogScope({super.key, required this.child}) : _controller = null;

  const HeroDialogScope._shared({
    required _HeroDialogHeroController controller,
    required this.child,
  }) : _controller = controller;

  final Widget child;
  final _HeroDialogHeroController? _controller;

  /// 取得最近的共享元素范围；没有时返回 `null`。
  static HeroDialogScopeState? maybeOf(BuildContext context) {
    return context.findAncestorStateOfType<HeroDialogScopeState>();
  }

  /// 取得最近的共享元素范围。
  static HeroDialogScopeState of(BuildContext context) {
    final state = maybeOf(context);
    assert(state != null, 'HeroDialogHero 必须位于 HeroDialogHeroScope 内。');
    return state!;
  }

  @override
  State<HeroDialogScope> createState() => HeroDialogScopeState();
}

/// [HeroDialogScope] 的状态。
class HeroDialogScopeState extends State<HeroDialogScope> {
  late final _controller = widget._controller ?? _HeroDialogHeroController();

  @override
  Widget build(BuildContext context) => widget.child;
}

/// 标记 Hero 弹窗中的共享元素。
///
/// 源组件和弹窗内组件使用相同 [tag]。飞行期间两端会自动隐藏，避免重复绘制；
/// 关闭弹窗后源组件会恢复显示。
class OverlayHero extends StatefulWidget {
  /// 创建 Hero 弹窗共享元素。
  const OverlayHero({
    required this.tag,
    required this.child,
    super.key,
    this.flightBuilder,
  });

  /// 用于配对源组件和弹窗组件的唯一标识。
  final Object tag;

  /// 共享元素的实际内容。
  final Widget child;

  /// 飞行层内容；默认使用弹窗端的 [child]。
  final HeroDialogFlightBuilder? flightBuilder;

  @override
  State<OverlayHero> createState() => _OverlayHeroState();
}

class _OverlayHeroState extends State<OverlayHero> {
  HeroDialogScopeState? _scope;
  var _visible = true;

  @override
  void didChangeDependencies() {
    super.didChangeDependencies();
    final scope = HeroDialogScope.maybeOf(context);
    if (_scope == scope) return;

    _scope?._controller.unregister(this);
    _scope = scope;
    _scope?._controller.register(this);
  }

  @override
  void dispose() {
    _scope?._controller.unregister(this);
    super.dispose();
  }

  Rect? rectIn(RenderBox overlayBox) {
    final box = context.findRenderObject();
    if (box is! RenderBox || !box.attached) return null;
    return Rect.fromPoints(
      overlayBox.globalToLocal(box.localToGlobal(Offset.zero)),
      overlayBox
          .globalToLocal(box.localToGlobal(box.size.bottomRight(Offset.zero))),
    );
  }

  Widget buildFlight(BuildContext context) {
    return widget.flightBuilder?.call(context, widget.child) ?? widget.child;
  }

  void setVisible(bool visible) {
    if (!mounted || _visible == visible) return;
    setState(() => _visible = visible);
  }

  @override
  Widget build(BuildContext context) {
    return Opacity(opacity: _visible ? 1 : 0, child: widget.child);
  }
}

final class _HeroDialogHeroController {
  final _sources = <Object, _OverlayHeroState>{};
  final _targets = <Object, _OverlayHeroState>{};
  var _isPresenting = false;

  void register(_OverlayHeroState hero) {
    final heroes = _isPresenting ? _targets : _sources;
    heroes[hero.widget.tag] = hero;
  }

  void unregister(_OverlayHeroState hero) {
    if (_sources[hero.widget.tag] == hero) _sources.remove(hero.widget.tag);
    if (_targets[hero.widget.tag] == hero) _targets.remove(hero.widget.tag);
  }

  bool beginPresentation() {
    if (_isPresenting) return false;
    _isPresenting = true;
    _targets.clear();
    return true;
  }

  List<_HeroOverlayFlight> get flights {
    return [
      for (final entry in _targets.entries)
        if (_sources[entry.key] case final source?)
          _HeroOverlayFlight(source: source, target: entry.value),
    ];
  }

  void endPresentation() {
    for (final hero in _sources.values) {
      hero.setVisible(true);
    }
    for (final hero in _targets.values) {
      hero.setVisible(true);
    }
    _targets.clear();
    _isPresenting = false;
  }
}

final class _HeroOverlayFlight {
  const _HeroOverlayFlight({required this.source, required this.target});

  final _OverlayHeroState source;
  final _OverlayHeroState target;
}

/// 不切换路由的 Hero 风格弹窗控制器。
final class HeroOverlay<T> {
  const HeroOverlay._({
    required this.closed,
    required void Function(T? result) dismiss,
  }) : _dismiss = dismiss;

  /// 弹窗关闭后返回的结果。
  final Future<T?> closed;

  final void Function(T? result) _dismiss;

  /// 关闭弹窗并返回 [result]。
  void dismiss([T? result]) => _dismiss(result);
}

/// 在当前页面的 [Overlay] 中打开 Hero 风格弹窗。
///
/// 此方法不切换 [Navigator] 路由，因此不会取消正在识别的手势。若调用点位于
/// [HeroDialogScope] 内，弹窗中相同 [OverlayHero.tag] 的组件会从源位置飞入；
/// 关闭时反向飞回。未配置 Scope 或没有匹配组件时，弹窗仍会使用普通淡入位移动画。
HeroOverlay<T> showHeroOverlay<T>(
  BuildContext context, {
  required WidgetBuilder builder,
  bool useRootOverlay = false,
  bool barrierDismissible = true,
  Color? barrierColor = Colors.black54,
  String? barrierLabel = '关闭弹窗',
  bool useSafeArea = true,
  Offset transitionOffset = const Offset(0, 20),
  Duration transitionDuration = const Duration(milliseconds: 200),
  Duration reverseTransitionDuration = const Duration(milliseconds: 160),
  Curve curve = Curves.easeOut,
  Curve reverseCurve = Curves.easeIn,
}) {
  assert(!barrierDismissible || barrierLabel != null);
  final scope = HeroDialogScope.maybeOf(context);
  final heroController = scope?._controller;
  final activeHeroController =
      heroController?.beginPresentation() ?? false ? heroController : null;

  final completer = Completer<T?>();
  final key = GlobalKey<_HeroOverlayState<T>>();
  late final OverlayEntry entry;
  var isClosed = false;

  void complete(T? result) {
    if (isClosed) return;

    isClosed = true;
    activeHeroController?.endPresentation();
    if (entry.mounted) entry.remove();
    completer.complete(result);
  }

  void dismiss(T? result) {
    if (isClosed) return;
    final state = key.currentState;
    if (state == null) {
      complete(result);
    } else {
      state.dismiss(result);
    }
  }

  entry = OverlayEntry(
    builder: (_) => _HeroOverlay<T>(
      key: key,
      builder: builder,
      heroController: activeHeroController,
      barrierDismissible: barrierDismissible,
      barrierColor: barrierColor,
      barrierLabel: barrierLabel,
      useSafeArea: useSafeArea,
      transitionOffset: transitionOffset,
      transitionDuration: transitionDuration,
      reverseTransitionDuration: reverseTransitionDuration,
      curve: curve,
      reverseCurve: reverseCurve,
      onDismiss: complete,
    ),
  );

  Overlay.of(context, rootOverlay: useRootOverlay).insert(entry);
  return HeroOverlay._(closed: completer.future, dismiss: dismiss);
}

class _HeroOverlay<T> extends StatefulWidget {
  const _HeroOverlay({
    super.key,
    required this.builder,
    required this.heroController,
    required this.barrierDismissible,
    required this.barrierColor,
    required this.barrierLabel,
    required this.useSafeArea,
    required this.transitionOffset,
    required this.transitionDuration,
    required this.reverseTransitionDuration,
    required this.curve,
    required this.reverseCurve,
    required this.onDismiss,
  });

  final WidgetBuilder builder;
  final _HeroDialogHeroController? heroController;
  final bool barrierDismissible;
  final Color? barrierColor;
  final String? barrierLabel;
  final bool useSafeArea;
  final Offset transitionOffset;
  final Duration transitionDuration;
  final Duration reverseTransitionDuration;
  final Curve curve;
  final Curve reverseCurve;
  final void Function(T? result) onDismiss;

  @override
  State<_HeroOverlay<T>> createState() => _HeroOverlayState<T>();
}

class _HeroOverlayState<T> extends State<_HeroOverlay<T>>
    with SingleTickerProviderStateMixin {
  var _isDismissing = false;
  var _hasFlights = false;

  late final _controller = AnimationController(
    vsync: this,
    duration: widget.transitionDuration,
    reverseDuration: widget.reverseTransitionDuration,
  );

  late final _animation = CurvedAnimation(
    parent: _controller,
    curve: widget.curve,
    reverseCurve: widget.reverseCurve,
  );

  @override
  void initState() {
    super.initState();
    _controller.addStatusListener(_handleAnimationStatus);
    WidgetsBinding.instance.addPostFrameCallback((_) {
      if (!mounted || _isDismissing) return;

      final flights =
          widget.heroController?.flights ?? const <_HeroOverlayFlight>[];
      for (final flight in flights) {
        flight.source.setVisible(false);
        flight.target.setVisible(false);
      }
      setState(() => _hasFlights = flights.isNotEmpty);
      _controller.forward();
    });
  }

  @override
  void dispose() {
    _animation.dispose();
    _controller.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final dialog = Center(child: widget.builder(context));
    final child = widget.heroController == null
        ? dialog
        : HeroDialogScope._shared(
            controller: widget.heroController!,
            child: dialog,
          );

    return AnimatedBuilder(
      animation: _animation,
      builder: (_, __) {
        final flights =
            widget.heroController?.flights ?? const <_HeroOverlayFlight>[];
        final overlayBox = Overlay.of(context).context.findRenderObject();
        final isFlighting = _hasFlights &&
            _animation.status != AnimationStatus.completed &&
            flights.isNotEmpty;
        return Stack(
          children: [
            ModalBarrier(
              dismissible: widget.barrierDismissible,
              color: widget.barrierColor?.withValues(
                alpha: widget.barrierColor!.a * _animation.value,
              ),
              semanticsLabel: widget.barrierLabel,
              onDismiss: () => dismiss(null),
            ),
            Opacity(
              opacity: isFlighting ? 0 : _animation.value,
              child: Transform.translate(
                offset: widget.transitionOffset * (1 - _animation.value),
                child: widget.useSafeArea ? SafeArea(child: child) : child,
              ),
            ),
            if (isFlighting && overlayBox is RenderBox)
              for (final flight in flights)
                if (flight.source.rectIn(overlayBox) case final sourceRect?)
                  if (flight.target.rectIn(overlayBox) case final targetRect?)
                    Positioned.fromRect(
                      rect: RectTween(begin: sourceRect, end: targetRect)
                          .transform(_animation.value)!,
                      child: IgnorePointer(
                        child: HeroMode(
                          enabled: false,
                          child: flight.target.buildFlight(context),
                        ),
                      ),
                    ),
          ],
        );
      },
    );
  }

  Future<void> dismiss(T? result) async {
    if (_isDismissing) return;

    _isDismissing = true;
    await _controller.reverse();
    widget.onDismiss(result);
  }

  void _handleAnimationStatus(AnimationStatus status) {
    if (status != AnimationStatus.completed || _isDismissing) return;

    for (final flight in widget.heroController?.flights ?? const []) {
      flight.target.setVisible(true);
    }
    setState(() {});
  }
}
