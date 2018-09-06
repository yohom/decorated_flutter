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
  static double kScreenWidth;
  static double kScreenHeight;

  /// 一个物理像素, 不建议使用, 渲染会有问题
  static double kOnePixel;

  /// 全局的theme
  static ThemeData kAppTheme;
  static TextTheme kTextTheme;
  static Color kPrimaryColor;
  static Color kPrimaryColorDark;

  static init(BuildContext context) {
    final media = MediaQuery.of(context);
    kScreenWidth = media.size.width;
    kScreenHeight = media.size.height;
    kOnePixel = 1 / media.devicePixelRatio;

    kAppTheme = Theme.of(context);
    kTextTheme = kAppTheme.textTheme;
    kPrimaryColor = kAppTheme.primaryColor;
    kPrimaryColorDark = kAppTheme.primaryColorDark;
  }
}
