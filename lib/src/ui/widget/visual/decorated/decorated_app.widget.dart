import 'package:decorated_flutter/decorated_flutter.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:flutter_localizations/flutter_localizations.dart';

@optionalTypeArgs
class DecoratedApp<B extends RootBLoC> extends StatelessWidget {
  const DecoratedApp({
    super.key,
    this.rootBLoC,
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
    @Deprecated('禁止再使用, 会出现潜在的手势冲突(比如和地图缩放手势冲突), 只在需要的地方使用')
    this.autoCloseKeyboard = const CloseKeyboardConfig(),
  })  : _isRouter = false,
        routeInformationProvider = null,
        routeInformationParser = null,
        routerDelegate = null,
        routerConfig = null,
        backButtonDispatcher = null;

  const DecoratedApp.router({
    super.key,
    this.rootBLoC,
    this.onGenerateTitle,
    this.theme,
    this.darkTheme,
    this.highContrastDarkTheme,
    this.highContrastTheme,
    this.themeMode,
    this.scrollBehavior,
    this.localizationsDelegates = const [],
    this.supportedLocales = const <Locale>[Locale('en', 'US')],
    this.locale,
    this.title = '',
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
    this.restorationScopeId,
    this.withCapturer = false,
    this.onNavigationNotification,
    // ------------------ navigator2专有 ------------------//
    this.routeInformationProvider,
    this.routeInformationParser,
    this.routerDelegate,
    this.routerConfig,
    this.backButtonDispatcher,
    // ------------------ navigator2专有 ------------------//
    this.autoCloseKeyboard = const CloseKeyboardConfig(),
  })  : _isRouter = true,
        navigatorObservers = const [],
        navigatorKey = null,
        onGenerateRoute = null,
        home = null,
        onGenerateInitialRoutes = null,
        onUnknownRoute = null,
        routes = const {},
        initialRoute = null;

  final B? rootBLoC;
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

  // ------------------ router专有 ------------------ //
  final RouteInformationProvider? routeInformationProvider;

  /// {@macro flutter.widgets.widgetsApp.routeInformationParser}
  final RouteInformationParser<Object>? routeInformationParser;

  /// {@macro flutter.widgets.widgetsApp.routerDelegate}
  final RouterDelegate<Object>? routerDelegate;

  /// {@macro flutter.widgets.widgetsApp.routerConfig}
  final RouterConfig<Object>? routerConfig;

  /// {@macro flutter.widgets.widgetsApp.backButtonDispatcher}
  final BackButtonDispatcher? backButtonDispatcher;
  // ------------------ router专有 ------------------ //

  /// 是否内建截图组件Capturer
  final bool withCapturer;

  /// 是否自动关闭输入法
  @Deprecated('禁止再使用, 会出现潜在的手势冲突(比如和地图缩放手势冲突), 只在需要的地方使用')
  final CloseKeyboardConfig? autoCloseKeyboard;

  /// 是否使用router
  final bool _isRouter;

  @override
  Widget build(BuildContext context) {
    Widget __builder(BuildContext context, Widget? child) {
      Widget result = builder != null ? builder!.call(context, child) : child!;

      if (withCapturer) {
        result = Capturer(child: result);
      }

      if (autoCloseKeyboard != null) {
        result = AutoCloseKeyboard(
          config: autoCloseKeyboard!,
          child: result,
        );
      }
      return result;
    }

    final child = _isRouter
        ? MaterialApp.router(
            title: title,
            builder: __builder,
            onGenerateTitle: onGenerateTitle,
            theme: theme?.let((self) =>
                kIsWeb ? self : self.useSystemChineseFont(Brightness.light)),
            darkTheme: darkTheme?.let((self) =>
                kIsWeb ? self : self.useSystemChineseFont(Brightness.dark)),
            themeMode: themeMode,
            scrollBehavior: scrollBehavior,
            debugShowCheckedModeBanner: debugShowCheckedModeBanner,
            localizationsDelegates: {
              ...localizationsDelegates,
              GlobalCupertinoLocalizations.delegate,
              GlobalMaterialLocalizations.delegate,
              GlobalWidgetsLocalizations.delegate
            },
            locale: locale,
            supportedLocales: supportedLocales,
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
            onNavigationNotification: onNavigationNotification,
            routeInformationProvider: routeInformationProvider,
            routeInformationParser: routeInformationParser,
            routerDelegate: routerDelegate,
            routerConfig: routerConfig,
          )
        : MaterialApp(
            title: title,
            builder: __builder,
            onGenerateTitle: onGenerateTitle,
            navigatorKey: navigatorKey ?? gNavigatorKey,
            theme: theme?.let((self) =>
                kIsWeb ? self : self.useSystemChineseFont(Brightness.light)),
            darkTheme: darkTheme?.let((self) =>
                kIsWeb ? self : self.useSystemChineseFont(Brightness.dark)),
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
