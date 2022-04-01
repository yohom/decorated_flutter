import 'package:decorated_flutter/src/bloc/bloc.export.dart';
import 'package:flutter/material.dart';

import 'size.x.dart';

extension BuildContextX on BuildContext {
  T of<T extends BLoC>() {
    return BLoCProvider.of<T>(this)!;
  }

  T? maybeOf<T extends BLoC>() {
    return BLoCProvider.of<T>(this);
  }

  ThemeData get theme {
    return Theme.of(this);
  }

  bool get isDarkMode {
    return Theme.of(this).brightness == Brightness.dark;
  }

  void clearFocus() {
    FocusScope.of(this).unfocus();
  }

  FormState get form {
    return Form.of(this)!;
  }

  double get height {
    return MediaQuery.of(this).size.height;
  }

  double get width {
    return MediaQuery.of(this).size.width;
  }

  double get physicalHeight {
    final data = MediaQuery.of(this);
    return data.size.height * data.devicePixelRatio;
  }

  double get physicalWidth {
    final data = MediaQuery.of(this);
    return data.size.width * data.devicePixelRatio;
  }

  EdgeInsets get padding {
    return MediaQuery.of(this).padding;
  }

  EdgeInsets get viewPadding {
    return MediaQuery.of(this).viewPadding;
  }

  EdgeInsets get viewInsets {
    return MediaQuery.of(this).viewInsets;
  }

  @Deprecated('跟BuildContext自身的size属性冲突')
  Size get size {
    return MediaQuery.of(this).size;
  }

  bool get isPortrait {
    return MediaQuery.of(this).size.isPortrait;
  }

  bool get isLandscape {
    return MediaQuery.of(this).size.isLandscape;
  }

  TextTheme get textTheme {
    return Theme.of(this).textTheme;
  }

  Color get backgroundColor {
    return Theme.of(this).backgroundColor;
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
    return PrimaryScrollController.of(this)?.animateTo(
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
