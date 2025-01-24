import 'package:decorated_flutter/src/bloc/bloc.export.dart';
import 'package:flutter/material.dart';

import '../utils/utils.export.dart';

extension BuildContextX on BuildContext {
  @Deprecated('重命名为find')
  T of<T extends BLoC>() {
    return BLoCProvider.of<T>(this)!;
  }

  T find<T extends BLoC>() {
    final bloc = BLoCProvider.of<T>(this);

    if (bloc == null) L.w('获取不到BLoC, 看看是不是搞错作用域了?');
    return bloc!;
  }

  @Deprecated('重命名为maybeFind')
  T? maybeOf<T extends BLoC>() {
    return BLoCProvider.of<T>(this);
  }

  T? maybeFind<T extends BLoC>() {
    return BLoCProvider.of<T>(this);
  }

  ThemeData get theme {
    return Theme.of(this);
  }

  bool get isDarkMode {
    return Theme.of(this).brightness == Brightness.dark;
  }

  void clearFocus() {
    // 参考 https://github.com/flutter/flutter/issues/54277#issuecomment-867119458
    final FocusScopeNode currentScope = FocusScope.of(this);
    if (!currentScope.hasPrimaryFocus && currentScope.hasFocus) {
      FocusManager.instance.primaryFocus?.unfocus();
    }
  }

  /// BuildContext对应的全局坐标
  @Deprecated('使用globalPosition代替')
  Offset get globalCoordinate => globalPosition;

  /// BuildContext对应的全局坐标
  Offset get globalPosition {
    final renderBox = findRenderObject() as RenderBox;
    return renderBox.localToGlobal(Offset.zero);
  }

  FormState get form {
    return Form.of(this);
  }

  ColorScheme get colorScheme {
    return theme.colorScheme;
  }

  Color get dividerColor {
    return theme.dividerTheme.color ?? theme.dividerColor;
  }

  double get height {
    return MediaQuery.sizeOf(this).height;
  }

  double get width {
    return MediaQuery.sizeOf(this).width;
  }

  double get physicalHeight {
    final height = MediaQuery.sizeOf(this).height;
    final devicePixelRatio = MediaQuery.devicePixelRatioOf(this);
    return height * devicePixelRatio;
  }

  double get physicalWidth {
    final width = MediaQuery.sizeOf(this).width;
    final devicePixelRatio = MediaQuery.devicePixelRatioOf(this);
    return width * devicePixelRatio;
  }

  EdgeInsets get padding {
    return MediaQuery.paddingOf(this);
  }

  EdgeInsets get viewPadding {
    return MediaQuery.viewPaddingOf(this);
  }

  EdgeInsets get viewInsets {
    return MediaQuery.viewInsetsOf(this);
  }

  @Deprecated('跟BuildContext自身的size属性冲突')
  Size get size {
    return MediaQuery.of(this).size;
  }

  bool get isPortrait {
    return MediaQuery.orientationOf(this) == Orientation.portrait;
  }

  bool get isLandscape {
    return MediaQuery.orientationOf(this) == Orientation.landscape;
  }

  TextTheme get textTheme {
    return Theme.of(this).textTheme;
  }

  Color get backgroundColor {
    return Theme.of(this).colorScheme.surface;
  }

  NavigatorState get rootNavigator {
    return Navigator.of(this, rootNavigator: true);
  }

  NavigatorState get navigator {
    return Navigator.of(this);
  }

  TabController? get tabController {
    return DefaultTabController.of(this);
  }

  Future<void> scrollToTop({Duration? duration, Curve? curve}) async {
    return PrimaryScrollController.of(this).animateTo(
      0,
      duration: duration ?? const Duration(milliseconds: 300),
      curve: curve ?? Curves.ease,
    );
  }

  Rect get rect {
    final box = findRenderObject() as RenderBox;
    return box.paintBounds;
  }

  /// 获取相对矩形
  ///
  /// offset还不是很好用, 参考的PopupMenuButton, 但是效果不好
  RelativeRect relativeRect([Offset offset = Offset.zero]) {
    final self = findRenderObject()! as RenderBox;
    final overlay = navigator.overlay!.context.findRenderObject()! as RenderBox;
    return RelativeRect.fromRect(
      Rect.fromPoints(
        self.localToGlobal(offset, ancestor: overlay),
        self.localToGlobal(
          self.size.bottomRight(Offset.zero) + offset,
          ancestor: overlay,
        ),
      ),
      Offset.zero & overlay.size,
    );
  }
}
