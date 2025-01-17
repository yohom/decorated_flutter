import 'dart:io';

import 'package:decorated_flutter/decorated_flutter.dart';
import 'package:decorated_flutter/src/utils/chinese_font.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:flutter_localizations/flutter_localizations.dart';

@optionalTypeArgs
class DecoratedApp<B extends RootBLoC> extends StatelessWidget {
  const DecoratedApp({
    super.key,
    this.rootBLoC,
    @Deprecated('已无作用, 直接使用DecoratedApp的参数即可') this.app = NIL,
    @Deprecated('暂无作用') this.preventTextScale = false,
    this.onGenerateTitle,
    this.onGenerateRoute,
    this.onGenerateInitialRoutes,
    this.onUnknownRoute,
    this.theme,
    this.darkTheme,
    this.highContrastDarkTheme,
    this.highContrastTheme,
    this.themeMode,
    this.scrollBehavior,
    this.localizationsDelegates = const [],
    this.supportedLocales = const <Locale>[Locale('en', 'US')],
    this.locale,
    this.navigatorKey,
    this.navigatorObservers = const [],
    this.title = '',
    @Deprecated('暂无作用, 直接嵌套ListTileTheme即可') this.listTileTheme,
    this.builder,
    this.debugShowCheckedModeBanner = false,
    this.onDispose,
    this.localeResolutionCallback,
    this.localeListResolutionCallback,
    this.actions,
    this.checkerboardOffscreenLayers = false,
    this.checkerboardRasterCacheImages = false,
    this.color,
    this.debugShowMaterialGrid = false,
    this.themeAnimationCurve = Curves.linear,
    this.themeAnimationDuration = kThemeAnimationDuration,
    this.themeAnimationStyle,
    this.scaffoldMessengerKey,
    this.shortcuts,
    this.showPerformanceOverlay = false,
    this.showSemanticsDebugger = false,
    this.initialRoute,
    this.restorationScopeId,
    this.home,
    this.withCapturer = false,
    this.onNavigationNotification,
    this.routes = const {},
  });

  final B? rootBLoC;
  final bool preventTextScale;
  final GenerateAppTitle? onGenerateTitle;
  final ThemeData? theme, darkTheme, highContrastDarkTheme, highContrastTheme;
  final ThemeMode? themeMode;
  final RouteFactory? onGenerateRoute;
  final InitialRouteListFactory? onGenerateInitialRoutes;
  final RouteFactory? onUnknownRoute;
  final ScrollBehavior? scrollBehavior;
  final Iterable<LocalizationsDelegate<dynamic>> localizationsDelegates;
  final Locale? locale;
  final Iterable<Locale> supportedLocales;
  final GlobalKey<NavigatorState>? navigatorKey;
  final List<NavigatorObserver> navigatorObservers;
  final String title;
  final ListTileThemeData? listTileTheme;
  final Widget app;
  final TransitionBuilder? builder;
  final bool debugShowCheckedModeBanner;
  final String? initialRoute;
  final VoidCallback? onDispose;

  /// {@macro flutter.widgets.LocaleResolutionCallback}
  final LocaleResolutionCallback? localeResolutionCallback;

  /// {@macro flutter.widgets.widgetsApp.localeListResolutionCallback}
  final LocaleListResolutionCallback? localeListResolutionCallback;

  /// {@macro flutter.widgets.widgetsApp.actions}
  final Map<Type, Action<Intent>>? actions;

  final bool checkerboardOffscreenLayers,
      checkerboardRasterCacheImages,
      debugShowMaterialGrid,
      showPerformanceOverlay,
      showSemanticsDebugger;
  final String? restorationScopeId;

  /// {@macro flutter.widgets.widgetsApp.color}
  final Color? color;

  final Curve themeAnimationCurve;
  final Duration themeAnimationDuration;
  final AnimationStyle? themeAnimationStyle;
  final NotificationListenerCallback<NavigationNotification>?
      onNavigationNotification;
  final Map<String, WidgetBuilder> routes;
  final GlobalKey<ScaffoldMessengerState>? scaffoldMessengerKey;
  final Map<ShortcutActivator, Intent>? shortcuts;
  final Widget? home;

  /// 是否内建截图组件Capturer
  final bool withCapturer;

  @override
  Widget build(BuildContext context) {
    final child = MaterialApp(
      title: title,
      builder: withCapturer
          ? (context, child) {
              return Capturer(child: builder?.call(context, child));
            }
          : builder,
      onGenerateTitle: onGenerateTitle,
      navigatorKey: navigatorKey ?? gNavigatorKey,
      theme: theme?.let((self) => (kIsWeb || Platform.isAndroid)
          ? self
          : self.useSystemChineseFont(Brightness.light)),
      darkTheme: darkTheme?.let((self) => (kIsWeb || Platform.isAndroid)
          ? self
          : self.useSystemChineseFont(Brightness.dark)),
      themeMode: themeMode,
      scrollBehavior: scrollBehavior,
      onGenerateRoute: onGenerateRoute,
      onGenerateInitialRoutes: onGenerateInitialRoutes,
      onUnknownRoute: onUnknownRoute,
      debugShowCheckedModeBanner: debugShowCheckedModeBanner,
      localizationsDelegates: {
        ...localizationsDelegates,
        GlobalCupertinoLocalizations.delegate,
        GlobalMaterialLocalizations.delegate,
        GlobalWidgetsLocalizations.delegate
      },
      locale: locale,
      supportedLocales: supportedLocales,
      navigatorObservers: navigatorObservers,
      localeListResolutionCallback: localeListResolutionCallback,
      localeResolutionCallback: localeResolutionCallback,
      actions: actions,
      checkerboardOffscreenLayers: checkerboardOffscreenLayers,
      checkerboardRasterCacheImages: checkerboardRasterCacheImages,
      color: color,
      debugShowMaterialGrid: debugShowMaterialGrid,
      themeAnimationCurve: themeAnimationCurve,
      themeAnimationDuration: themeAnimationDuration,
      themeAnimationStyle: themeAnimationStyle,
      scaffoldMessengerKey: scaffoldMessengerKey,
      shortcuts: shortcuts,
      showPerformanceOverlay: showPerformanceOverlay,
      restorationScopeId: restorationScopeId,
      showSemanticsDebugger: showSemanticsDebugger,
      highContrastDarkTheme: highContrastDarkTheme,
      highContrastTheme: highContrastTheme,
      initialRoute: initialRoute,
      onNavigationNotification: onNavigationNotification,
      routes: routes,
      home: home,
    );
    return rootBLoC != null
        ? BLoCProvider<B>(bloc: rootBLoC!, onDispose: onDispose, child: child)
        : child;
  }
}
