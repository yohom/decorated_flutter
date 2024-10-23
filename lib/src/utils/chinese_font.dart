// https://github.com/LastMonopoly/chinese_font_library 的简化实现

import 'dart:io';
import 'dart:ui';

import 'package:flutter/material.dart';
import 'package:flutter/services.dart';

class SystemChineseFont {
  const SystemChineseFont._();

  /// Chinese font family fallback, for iOS & macOS
  static const List<String> appleFontFamily = [
    // '.SF UI Text',
    '.AppleSystemUIFont',
    'PingFang SC',
  ];

  /// Chinese font family fallback, for xiaomi & redmi phone
  static const List<String> xiaomiFontFamily = [
    'miui',
    'mipro',
  ];

  /// Chinese font family fallback, for windows
  static const List<String> windowsFontFamily = [
    'Microsoft YaHei',
  ];

  static const systemFont = "system-font";

  static bool systemFontLoaded = false;

  /// Chinese font family fallback, for VIVO Origin OS 1.0
  static final vivoSystemFont = DynamicFont.file(
    fontFamily: systemFont,
    filepath: '/system/fonts/DroidSansFallbackMonster.ttf',
  );

  /// Chinese font family fallback, for honor Magic UI 4.0
  static final honorSystemFont = DynamicFont.file(
    fontFamily: systemFont,
    filepath: '/system/fonts/DroidSansChinese.ttf',
  );

  /// Chinese font family fallback, for most platforms
  static List<String> get fontFamilyFallback {
    if (!systemFontLoaded) {
      // honorSystemFont.load();
      () async {
        final vivoFont = File("/system/fonts/VivoFont.ttf");
        if ((await vivoFont.exists()) &&
            (await vivoFont.resolveSymbolicLinks())
                .contains("DroidSansFallbackBBK")) {
          await vivoSystemFont.load();
        }
      }();
      systemFontLoaded = true;
    }

    return [
      systemFont,
      "sans-serif",
      ...appleFontFamily,
      ...xiaomiFontFamily,
      ...windowsFontFamily,
    ];
  }

  /// Text style with updated fontFamilyFallback & fontVariations
  static TextStyle get textStyle {
    return const TextStyle().useSystemChineseFont();
  }

  /// Text theme with updated fontFamilyFallback & fontVariations
  static TextTheme textTheme(Brightness brightness) {
    switch (brightness) {
      case Brightness.dark:
        return Typography.material2021()
            .white
            .apply(fontFamilyFallback: fontFamilyFallback);
      case Brightness.light:
        return Typography.material2021()
            .black
            .apply(fontFamilyFallback: fontFamilyFallback);
    }
  }
}

extension TextStyleUseSystemChineseFont on TextStyle {
  /// Add fontFamilyFallback & fontVariation to original font style
  TextStyle useSystemChineseFont() {
    return copyWith(
      fontFamilyFallback: [
        ...?fontFamilyFallback,
        ...SystemChineseFont.fontFamilyFallback,
      ],
      fontVariations: [
        ...?fontVariations,
        if (fontWeight != null)
          FontVariation('wght', (fontWeight!.index + 1) * 100),
      ],
    );
  }
}

extension TextThemeUseSystemChineseFont on TextTheme {
  /// Add fontFamilyFallback & fontVariation to original text theme
  TextTheme useSystemChineseFont(Brightness brightness) {
    return SystemChineseFont.textTheme(brightness).merge(this);
  }
}

extension ThemeDataUseSystemChineseFont on ThemeData {
  /// Add fontFamilyFallback & fontVariation to original theme data
  ThemeData useSystemChineseFont(Brightness brightness) {
    return copyWith(textTheme: textTheme.useSystemChineseFont(brightness));
  }
}

enum _FontSource { asset, file }

class DynamicFont {
  final String fontFamily;
  final String uri;
  final _FontSource _source;

  /// Use the font from AssetBundle, [key] is the same as in [rootBundle.load]
  DynamicFont.asset({required this.fontFamily, required String key})
      : _source = _FontSource.asset,
        uri = key;

  /// Use the font from [filepath]
  DynamicFont.file({required this.fontFamily, required String filepath})
      : _source = _FontSource.file,
        uri = filepath;

  bool? overwrite;

  Future<bool> load() async {
    switch (_source) {
      case _FontSource.asset:
        try {
          final loader = FontLoader(fontFamily);
          final fontData = rootBundle.load(uri);
          loader.addFont(fontData);
          await loader.load();
          return true;
        } catch (e) {
          debugPrint("Font asset error!!!");
          debugPrint(e.toString());
          return false;
        }
      case _FontSource.file:
        if (!await File(uri).exists()) return false;
        try {
          await loadFontFromList(
            await File(uri).readAsBytes(),
            fontFamily: fontFamily,
          );
          return true;
        } catch (e) {
          debugPrint("Font file error!!!");
          debugPrint(e.toString());
          return false;
        }
    }
  }
}
