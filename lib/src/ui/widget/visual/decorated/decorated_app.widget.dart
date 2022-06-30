import 'package:decorated_flutter/decorated_flutter.dart';
import 'package:flutter/material.dart';
import 'package:flutter_localizations/flutter_localizations.dart';
import 'package:oktoast/oktoast.dart';

class DecoratedApp<B extends RootBLoC> extends StatelessWidget {
  DecoratedApp({
    Key? key,
    B? rootBLoC,
    @Deprecated('已无作用, 直接使用DecoratedApp的参数即可') this.app = NIL,
    @Deprecated('暂无作用') this.preventTextScale = false,
    this.onGenerateTitle,
    this.onGenerateRoute,
    this.theme,
    this.darkTheme,
    this.themeMode,
    this.scrollBehavior,
    this.localizationsDelegates = const [],
    this.supportedLocales = const <Locale>[Locale('en', 'US')],
    this.locale,
    this.navigatorKey,
    this.navigatorObservers = const [],
    this.title = '',
  })  : rootBLoC = rootBLoC ?? get(),
        super(key: key);

  final B rootBLoC;
  final bool preventTextScale;
  final GenerateAppTitle? onGenerateTitle;
  final ThemeData? theme, darkTheme;
  final ThemeMode? themeMode;
  final RouteFactory? onGenerateRoute;
  final ScrollBehavior? scrollBehavior;
  final Iterable<LocalizationsDelegate<dynamic>> localizationsDelegates;
  final Locale? locale;
  final Iterable<Locale> supportedLocales;
  final GlobalKey<NavigatorState>? navigatorKey;
  final List<NavigatorObserver> navigatorObservers;
  final String title;
  final Widget app;

  @override
  Widget build(BuildContext context) {
    return BLoCProvider<B>(
      bloc: rootBLoC,
      onDispose: () {
        // 释放log的定时写日志任务
        L.dispose();
      },
      child: OKToast(
        duration: const Duration(seconds: 3),
        radius: 4,
        dismissOtherOnShow: true,
        animationBuilder: const ToastAnimBuilder(),
        movingOnWindowChange: false,
        child: MaterialApp(
          title: title,
          onGenerateTitle: onGenerateTitle,
          navigatorKey: navigatorKey ?? gNavigatorKey,
          theme: theme,
          darkTheme: darkTheme,
          themeMode: themeMode,
          scrollBehavior: scrollBehavior,
          onGenerateRoute: onGenerateRoute,
          localizationsDelegates: {
            ...localizationsDelegates,
            GlobalCupertinoLocalizations.delegate,
            GlobalMaterialLocalizations.delegate,
            GlobalWidgetsLocalizations.delegate
          },
          locale: locale,
          supportedLocales: supportedLocales,
          navigatorObservers: navigatorObservers,
        ),
      ),
    );
  }
}
