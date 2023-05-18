import 'package:decorated_flutter/src/extension/extension.export.dart';
import 'package:decorated_flutter/src/ui/ui.export.dart';
import 'package:decorated_flutter/src/utils/utils.export.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';

import 'bloc/bloc.export.dart';
import 'model/model.export.dart';

@Deprecated('暂无使用')
class DecoratedCupertinoRoute<B extends BLoC, T extends Object>
    extends CupertinoPageRoute<T> {
  DecoratedCupertinoRoute({
    Key? key,
    required this.screen,
    this.bloc,
    this.autoCloseKeyboard = true,
    this.init,
    this.animate = true,
    this.onLateinit,
    this.withForm = false,
    this.withAnalytics = true,
    this.tabControllerConfig,
    this.onDisposed,
    this.onWillPop,
    this.systemUiOverlayStyle,
    this.autoDispose = true,
    required String routeName,
    super.fullscreenDialog,
    super.maintainState,
  })  : // 要么同时设置泛型B和bloc参数, 要么就都不设置
        assert((B != BLoC && bloc != null) || (B == BLoC && bloc == null)),
        super(
          builder: (context) => screen,
          settings: RouteSettings(name: routeName),
        );

  /// 直接传递的BLoC
  final B? bloc;

  /// child
  final Widget screen;

  /// 是否自动关闭输入法
  final bool autoCloseKeyboard;

  /// 初始化方法
  final InitCallback<B>? init;

  /// 是否执行动画
  final bool animate;

  /// 入场动画结束后的初始化方法
  final InitCallback<B>? onLateinit;

  /// 是否带有表单
  final bool withForm;

  /// 是否分析页面并上传
  final bool withAnalytics;

  /// 如果需要TabBar, 则配置这个对象
  final TabControllerConfig? tabControllerConfig;

  final VoidCallback? onDisposed;

  final WillPopCallback? onWillPop;

  /// 系统ui
  final SystemUiOverlayStyle? systemUiOverlayStyle;

  /// 是否自动dispose BLoC
  final bool autoDispose;

  /// 是否已经初始化
  bool _inited = false;

  @override
  Widget buildPage(
    BuildContext context,
    Animation<double> animation,
    Animation<double> secondaryAnimation,
  ) {
    Widget result;
    if (bloc != null) {
      result = BLoCProvider<B>(
        bloc: bloc!,
        init: init,
        onDispose: onDisposed,
        autoDispose: autoDispose,
        child: builder(context),
      );
    } else {
      result = builder(context);
    }

    // 是否自动收起键盘
    if (autoCloseKeyboard) {
      result = AutoCloseKeyboard(child: result);
    }

    // 是否带有表单
    if (withForm) {
      result = Form(child: result);
    }

    if (tabControllerConfig != null) {
      result = DefaultTabController(
        length: tabControllerConfig!.length,
        initialIndex: tabControllerConfig!.initialIndex,
        child: result,
      );
    }

    if (systemUiOverlayStyle != null) {
      // 自动对暗黑模式做切换
      SystemUiOverlayStyle style = systemUiOverlayStyle!;
      if (context.isDarkMode) {
        if (style == SystemUiOverlayStyle.dark) {
          style = SystemUiOverlayStyle.light;
        } else if (style == SystemUiOverlayStyle.light) {
          style = SystemUiOverlayStyle.dark;
        }
      }
      result = AnnotatedRegion<SystemUiOverlayStyle>(
        value: style,
        child: result,
      );
    }

    if (onWillPop != null) {
      result = WillPopScope(onWillPop: onWillPop, child: result);
    }

    return Material(
      key: settings.name == null ? null : Key(settings.name!),
      child: result,
    );
  }

  @override
  Widget buildTransitions(BuildContext context, Animation<double> animation,
      Animation<double> secondaryAnimation, Widget child) {
    animation.addStatusListener((status) {
      // 如果是懒加载, 那么动画结束时开始初始化
      if (status == AnimationStatus.completed &&
          onLateinit != null &&
          bloc != null &&
          !_inited) {
        onLateinit!(bloc!);
        _inited = true;
      }
    });
    return animate
        ? super.buildTransitions(context, animation, secondaryAnimation, child)
        : child;
  }
}

@Deprecated('暂时无用')
enum SpringButtonType {
  onlyScale,
  withOpacity,
}

@Deprecated('暂时无用')
class SpringButton extends StatefulWidget {
  ///Use this value to determine the type of animation to be played.
  final SpringButtonType springButtonType;

  ///The widget that is to be displayed on your regular UI.
  final Widget uiChild;

  ///Set this to true if your [uiChild] doesn't change at runtime.
  final bool useCache;

  ///Use this value to determine the alignment of the animation.
  final Alignment alignment;

  ///Use this value to determine the scaling factor while the animation is being played. Choose a value between 0.0 and 1.0.
  final double scaleCoefficient;

  ///Use this value to determine the duration of the animation.
  final int duration;

  ///Delegate for gesture callback.
  final GestureTapDownCallback? onTapDown;

  ///Delegate for gesture callback.
  final GestureTapUpCallback? onTapUp;

  ///Delegate for gesture callback.
  final GestureTapCallback? onTap;

  ///Delegate for gesture callback.
  final GestureTapCancelCallback? onTapCancel;

  ///Delegate for gesture callback.
  final GestureTapDownCallback? onSecondaryTapDown;

  ///Delegate for gesture callback.
  final GestureTapUpCallback? onSecondaryTapUp;

  ///Delegate for gesture callback.
  final GestureTapCancelCallback? onSecondaryTapCancel;

  ///Delegate for gesture callback.
  final GestureTapCallback? onDoubleTap;

  ///Delegate for gesture callback.
  final GestureLongPressCallback? onLongPress;

  ///Delegate for gesture callback.
  final GestureLongPressStartCallback? onLongPressStart;

  ///Delegate for gesture callback.
  final GestureLongPressMoveUpdateCallback? onLongPressMoveUpdate;

  ///Delegate for gesture callback.
  final GestureLongPressUpCallback? onLongPressUp;

  ///Delegate for gesture callback.
  final GestureLongPressEndCallback? onLongPressEnd;

  ///Delegate for gesture callback.
  final GestureDragDownCallback? onVerticalDragDown;

  ///Delegate for gesture callback.
  final GestureDragStartCallback? onVerticalDragStart;

  ///Delegate for gesture callback.
  final GestureDragUpdateCallback? onVerticalDragUpdate;

  ///Delegate for gesture callback.
  final GestureDragEndCallback? onVerticalDragEnd;

  ///Delegate for gesture callback.
  final GestureDragCancelCallback? onVerticalDragCancel;

  ///Delegate for gesture callback.
  final GestureDragDownCallback? onHorizontalDragDown;

  ///Delegate for gesture callback.
  final GestureDragStartCallback? onHorizontalDragStart;

  ///Delegate for gesture callback.
  final GestureDragUpdateCallback? onHorizontalDragUpdate;

  ///Delegate for gesture callback.
  final GestureDragEndCallback? onHorizontalDragEnd;

  ///Delegate for gesture callback.
  final GestureDragCancelCallback? onHorizontalDragCancel;

  ///Delegate for gesture callback.
  final GestureDragDownCallback? onPanDown;

  ///Delegate for gesture callback.
  final GestureDragStartCallback? onPanStart;

  ///Delegate for gesture callback.
  final GestureDragUpdateCallback? onPanUpdate;

  ///Delegate for gesture callback.
  final GestureDragEndCallback? onPanEnd;

  ///Delegate for gesture callback.
  final GestureDragCancelCallback? onPanCancel;

  ///Delegate for gesture callback.
  final GestureScaleStartCallback? onScaleStart;

  ///Delegate for gesture callback.
  final GestureScaleUpdateCallback? onScaleUpdate;

  ///Delegate for gesture callback.
  final GestureScaleEndCallback? onScaleEnd;

  ///Delegate for gesture callback.
  final GestureForcePressStartCallback? onForcePressStart;

  ///Delegate for gesture callback.
  final GestureForcePressPeakCallback? onForcePressPeak;

  ///Delegate for gesture callback.
  final GestureForcePressUpdateCallback? onForcePressUpdate;

  ///Delegate for gesture callback.
  final GestureForcePressEndCallback? onForcePressEnd;

  const SpringButton(
    this.springButtonType,
    this.uiChild, {
    super.key,
    this.useCache = true,
    this.alignment = Alignment.center,
    this.scaleCoefficient = 0.75,
    this.duration = 1000,
    this.onTapDown,
    this.onTapUp,
    this.onTap,
    this.onTapCancel,
    this.onSecondaryTapDown,
    this.onSecondaryTapUp,
    this.onSecondaryTapCancel,
    this.onDoubleTap,
    this.onLongPress,
    this.onLongPressStart,
    this.onLongPressMoveUpdate,
    this.onLongPressUp,
    this.onLongPressEnd,
    this.onVerticalDragDown,
    this.onVerticalDragStart,
    this.onVerticalDragUpdate,
    this.onVerticalDragEnd,
    this.onVerticalDragCancel,
    this.onHorizontalDragDown,
    this.onHorizontalDragStart,
    this.onHorizontalDragUpdate,
    this.onHorizontalDragEnd,
    this.onHorizontalDragCancel,
    this.onForcePressStart,
    this.onForcePressPeak,
    this.onForcePressUpdate,
    this.onForcePressEnd,
    this.onPanDown,
    this.onPanStart,
    this.onPanUpdate,
    this.onPanEnd,
    this.onPanCancel,
    this.onScaleStart,
    this.onScaleUpdate,
    this.onScaleEnd,
  })  : assert(scaleCoefficient >= 0.0 && scaleCoefficient <= 1.0);

  @override
  // ignore: no_logic_in_create_state
  SpringButtonState createState() => SpringButtonState(
        springButtonType,
        useCache,
        alignment,
        scaleCoefficient,
      );
}

class SpringButtonState extends State<SpringButton>
    with SingleTickerProviderStateMixin {
  final SpringButtonType springButtonType;
  Widget? uiChild;
  final bool useCache;
  final Alignment alignment;
  final double scaleCoefficient;

  ///The [AnimationController] used to create the spring effect.
  late AnimationController animationController;
  late Animation<double> animation;

  bool isSpringDown = false;

  bool isEnabled = true;

  ///Use this value to determine the depth of debug logging that is actually only here for myself and the Swiss scientists.
  final int _debugLevel = 0;

  SpringButtonState(
    this.springButtonType,
    this.useCache,
    this.alignment,
    this.scaleCoefficient,
  );

  @override
  void initState() {
    super.initState();

    if (useCache) uiChild = wrapper();

    animationController = AnimationController(
      vsync: this,
      lowerBound: 0.0,
      upperBound: 1.0,
      duration: Duration(milliseconds: widget.duration),
    );
    animationController.value = 1;
    animation = Tween(
      begin: scaleCoefficient,
      end: 1.0,
    ).animate(
      CurvedAnimation(
        parent: animationController,
        curve: Curves.elasticOut,
      ),
    );
  }

  @override
  void dispose() {
    animationController.dispose();

    super.dispose();
  }

  bool get hasMultiple {
    List<bool> list = [
      hasTap,
      hasSecondaryTap,
      hasDoubleTap,
      hasLongPress,
      hasVerticalDrag,
      hasHorizontalDrag,
      hasForcePress,
      hasPan,
      hasScale
    ];
    return list.where((bool b) => b).length > 1;
  }

  bool get hasTap =>
      widget.onTapDown != null ||
      widget.onTapUp != null ||
      widget.onTap != null ||
      widget.onTapCancel != null;
  bool get hasSecondaryTap =>
      widget.onSecondaryTapDown != null ||
      widget.onSecondaryTapUp != null ||
      widget.onSecondaryTapCancel != null;
  bool get hasDoubleTap => widget.onDoubleTap != null;
  bool get hasLongPress =>
      widget.onLongPress != null ||
      widget.onLongPressStart != null ||
      widget.onLongPressMoveUpdate != null ||
      widget.onLongPressUp != null ||
      widget.onLongPressEnd != null;
  bool get hasVerticalDrag =>
      widget.onVerticalDragDown != null ||
      widget.onVerticalDragStart != null ||
      widget.onVerticalDragUpdate != null ||
      widget.onVerticalDragEnd != null ||
      widget.onVerticalDragCancel != null;
  bool get hasHorizontalDrag =>
      widget.onHorizontalDragDown != null ||
      widget.onHorizontalDragStart != null ||
      widget.onHorizontalDragUpdate != null ||
      widget.onHorizontalDragEnd != null ||
      widget.onHorizontalDragCancel != null;
  bool get hasForcePress =>
      widget.onForcePressStart != null ||
      widget.onForcePressPeak != null ||
      widget.onForcePressUpdate != null ||
      widget.onForcePressEnd != null;
  bool get hasPan =>
      widget.onPanDown != null ||
      widget.onPanStart != null ||
      widget.onPanUpdate != null ||
      widget.onPanCancel != null;
  bool get hasScale =>
      widget.onScaleStart != null ||
      widget.onScaleUpdate != null ||
      widget.onScaleEnd != null;

  void enable() {
    if (!isEnabled) {
      animationController.value = 1.0;
      isSpringDown = false;
      isEnabled = true;
    }
  }

  void disable() {
    if (isEnabled) {
      animationController.value = 1.0;
      isSpringDown = false;
      isEnabled = false;
    }
  }

  void springDown() {
    if (!isEnabled) return;

    if (_debugLevel > 0) debugPrint("springDown");

    isSpringDown = true;
    animationController.value = 0;
  }

  Future spring() async {
    if (!isEnabled) return;

    if (_debugLevel > 0) debugPrint("spring-1");

    isSpringDown = false;

    if (hasMultiple) await Future.delayed(const Duration(milliseconds: 5));

    if (_debugLevel > 0) debugPrint("spring-2");

    if (!isSpringDown) animationController.forward();
  }

  Future springUp() async {
    if (!isEnabled) return;

    if (_debugLevel > 0) debugPrint("springUp-1");

    isSpringDown = false;

    if (hasMultiple) await Future.delayed(const Duration(milliseconds: 500));

    if (_debugLevel > 0) debugPrint("springUp-2");

    if (!isSpringDown) animationController.value = 1;
  }

  Widget wrapper() {
    return GestureDetector(
      behavior: HitTestBehavior.translucent,
      onTapDown: !hasTap
          ? null
          : (_) {
              springDown();
              if (widget.onTapDown != null && isEnabled) widget.onTapDown!(_);
            },
      onTapUp: !hasTap
          ? null
          : (_) {
              spring();
              if (widget.onTapUp != null && isEnabled) widget.onTapUp!(_);
            },
      onTap: !hasTap
          ? null
          : () {
              if (widget.onTap != null && isEnabled) widget.onTap!();
            },
      onTapCancel: !hasTap
          ? null
          : () {
              springUp();
              if (widget.onTapCancel != null && isEnabled) {
                widget.onTapCancel!();
              }
            },
      onSecondaryTapDown: !hasSecondaryTap
          ? null
          : (_) {
              springDown();
              if (widget.onSecondaryTapDown != null && isEnabled) {
                widget.onSecondaryTapDown!(_);
              }
            },
      onSecondaryTapUp: !hasSecondaryTap
          ? null
          : (_) {
              spring();
              if (widget.onSecondaryTapUp != null && isEnabled) {
                widget.onSecondaryTapUp!(_);
              }
            },
      onSecondaryTapCancel: !hasSecondaryTap
          ? null
          : () {
              springUp();
              if (widget.onSecondaryTapCancel != null && isEnabled) {
                widget.onSecondaryTapCancel!();
              }
            },
      onDoubleTap: !hasDoubleTap
          ? null
          : () {
              springDown();
              spring();
              if (widget.onDoubleTap != null && isEnabled) {
                widget.onDoubleTap!();
              }
            },
      onLongPress: !hasLongPress
          ? null
          : () {
              if (widget.onLongPress != null && isEnabled) {
                widget.onLongPress!();
              }
            },
      onLongPressStart: !hasLongPress
          ? null
          : (_) {
              springDown();
              if (widget.onLongPressStart != null && isEnabled) {
                widget.onLongPressStart!(_);
              }
            },
      onLongPressMoveUpdate: !hasLongPress
          ? null
          : (_) {
              if (widget.onLongPressMoveUpdate != null && isEnabled) {
                widget.onLongPressMoveUpdate!(_);
              }
            },
      onLongPressUp: !hasLongPress
          ? null
          : () {
              spring();
              if (widget.onLongPressUp != null && isEnabled) {
                widget.onLongPressUp!();
              }
            },
      onLongPressEnd: !hasLongPress
          ? null
          : (_) {
              if (widget.onLongPressEnd != null && isEnabled) {
                widget.onLongPressEnd!(_);
              }
            },
      onVerticalDragDown: !hasVerticalDrag
          ? null
          : (_) {
              if (widget.onVerticalDragDown != null && isEnabled) {
                widget.onVerticalDragDown!(_);
              }
            },
      onVerticalDragStart: !hasVerticalDrag
          ? null
          : (_) {
              springDown();
              if (widget.onVerticalDragStart != null && isEnabled) {
                widget.onVerticalDragStart!(_);
              }
            },
      onVerticalDragUpdate: !hasVerticalDrag
          ? null
          : (_) {
              if (widget.onVerticalDragUpdate != null && isEnabled) {
                widget.onVerticalDragUpdate!(_);
              }
            },
      onVerticalDragEnd: !hasVerticalDrag
          ? null
          : (_) {
              spring();
              if (widget.onVerticalDragEnd != null && isEnabled) {
                widget.onVerticalDragEnd!(_);
              }
            },
      onVerticalDragCancel: !hasVerticalDrag
          ? null
          : () {
              springUp();
              if (widget.onVerticalDragCancel != null && isEnabled) {
                widget.onVerticalDragCancel!();
              }
            },
      onHorizontalDragDown: !hasHorizontalDrag
          ? null
          : (_) {
              if (widget.onHorizontalDragDown != null && isEnabled) {
                widget.onHorizontalDragDown!(_);
              }
            },
      onHorizontalDragStart: !hasHorizontalDrag
          ? null
          : (_) {
              springDown();
              if (widget.onHorizontalDragStart != null && isEnabled) {
                widget.onHorizontalDragStart!(_);
              }
            },
      onHorizontalDragUpdate: !hasHorizontalDrag
          ? null
          : (_) {
              if (widget.onHorizontalDragUpdate != null && isEnabled) {
                widget.onHorizontalDragUpdate!(_);
              }
            },
      onHorizontalDragEnd: !hasHorizontalDrag
          ? null
          : (_) {
              spring();
              if (widget.onHorizontalDragEnd != null && isEnabled) {
                widget.onHorizontalDragEnd!(_);
              }
            },
      onHorizontalDragCancel: !hasHorizontalDrag
          ? null
          : () {
              springUp();
              if (widget.onHorizontalDragCancel != null && isEnabled) {
                widget.onHorizontalDragCancel!();
              }
            },
      onForcePressStart: !hasForcePress
          ? null
          : (_) {
              springDown();
              if (widget.onForcePressStart != null && isEnabled) {
                widget.onForcePressStart!(_);
              }
            },
      onForcePressPeak: !hasForcePress
          ? null
          : (_) {
              if (widget.onForcePressPeak != null && isEnabled) {
                widget.onForcePressPeak!(_);
              }
            },
      onForcePressUpdate: !hasForcePress
          ? null
          : (_) {
              if (widget.onForcePressUpdate != null && isEnabled) {
                widget.onForcePressUpdate!(_);
              }
            },
      onForcePressEnd: !hasForcePress
          ? null
          : (_) {
              spring();
              if (widget.onForcePressEnd != null && isEnabled) {
                widget.onForcePressEnd!(_);
              }
            },
      onPanDown: !hasPan
          ? null
          : (_) {
              if (widget.onPanDown != null && isEnabled) widget.onPanDown!(_);
            },
      onPanStart: !hasPan
          ? null
          : (_) {
              springDown();
              if (widget.onPanStart != null && isEnabled) widget.onPanStart!(_);
            },
      onPanUpdate: !hasPan
          ? null
          : (_) {
              if (widget.onPanUpdate != null && isEnabled) {
                widget.onPanUpdate!(_);
              }
            },
      onPanEnd: !hasPan
          ? null
          : (_) {
              spring();
              if (widget.onPanEnd != null && isEnabled) widget.onPanEnd!(_);
            },
      onPanCancel: !hasPan
          ? null
          : () {
              springUp();
              if (widget.onPanCancel != null && isEnabled) {
                widget.onPanCancel!();
              }
            },
      onScaleStart: !hasScale
          ? null
          : (_) {
              springDown();
              if (widget.onScaleStart != null && isEnabled) {
                widget.onScaleStart!(_);
              }
            },
      onScaleUpdate: !hasScale
          ? null
          : (_) {
              if (widget.onScaleUpdate != null && isEnabled) {
                widget.onScaleUpdate!(_);
              }
            },
      onScaleEnd: !hasScale
          ? null
          : (_) {
              spring();
              if (widget.onScaleEnd != null && isEnabled) widget.onScaleEnd!(_);
            },
      child: widget.uiChild,
    );
  }

  @override
  Widget build(BuildContext context) {
    if (springButtonType == SpringButtonType.withOpacity) {
      return AnimatedBuilder(
        animation: animation,
        child: useCache ? uiChild : null,
        builder: (BuildContext context, Widget? cachedChild) {
          return Opacity(
            opacity: animation.value.clamp(0.5, 1.0),
            child: Transform.scale(
              scale: animation.value,
              alignment: alignment,
              child: useCache ? cachedChild : wrapper(),
            ),
          );
        },
      );
    }
    return AnimatedBuilder(
      animation: animation,
      child: useCache ? uiChild : null,
      builder: (BuildContext context, Widget? cachedChild) {
        return Transform.scale(
          scale: animation.value,
          child: useCache ? cachedChild : wrapper(),
        );
      },
    );
  }
}
