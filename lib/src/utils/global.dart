import 'package:flutter/material.dart';

/// 全局常量
class Global {
  static const kTrue = 'true';
  static const kFalse = 'false';

  /// 需要手动去android和ios工程中限定设备方向, 不然如果旋转了屏幕的话, 这里的值就不准了
  /// android:
  ///   Manifest.xml activity节点设置android:screenOrientation为portrait
  /// ios:
  ///   点击项目, General标签, Device Orientation只选择Portrait
  static double screenWidth;
  static double screenHeight;

  /// 一个物理像素, 不建议使用, 渲染会有问题
  static double onePixel;

  /// 全局的theme
  static ThemeData appTheme;
  static TextTheme textTheme;
  static Color primaryColor;
  static Color primaryColorDark;

  static bool isIphoneX;

  static init(BuildContext context) {
    final media = MediaQuery.of(context);
    screenWidth = media.size.width;
    screenHeight = media.size.height;
    onePixel = 1 / media.devicePixelRatio;

    appTheme = Theme.of(context);
    textTheme = appTheme.textTheme;
    primaryColor = appTheme.primaryColor;
    primaryColorDark = appTheme.primaryColorDark;

    isIphoneX = media.size.height == 812;
  }
}
