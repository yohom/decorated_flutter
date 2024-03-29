import 'package:decorated_flutter/decorated_flutter.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';

class RuntimeScaffold<T extends LocalBLoC> extends StatelessWidget {
  const RuntimeScaffold({
    super.key,
    this.appBar,
    this.body,
    this.floatingActionButton,
    this.floatingActionButtonLocation,
    this.floatingActionButtonAnimator,
    this.persistentFooterButtons,
    this.drawer,
    this.bottomNavigationBar,
    this.bottomSheet,
    this.backgroundColor,
    this.resizeToAvoidBottomPadding = true,
    this.primary = true,
  });

  //region Scaffold
  final PreferredSizeWidget? appBar;

  final Widget? body;

  final Widget? floatingActionButton;

  final FloatingActionButtonLocation? floatingActionButtonLocation;

  final FloatingActionButtonAnimator? floatingActionButtonAnimator;

  final List<Widget>? persistentFooterButtons;

  final Widget? drawer;

  final Color? backgroundColor;

  final Widget? bottomNavigationBar;

  final Widget? bottomSheet;

  final bool resizeToAvoidBottomPadding;

  final bool primary;

  //endregion

  @override
  Widget build(BuildContext context) {
    Widget? runtimeInfoWidget;
    if (!kReleaseMode) {
      final bloc = BLoCProvider.of<T>(context);
      runtimeInfoWidget = Drawer(
        child: SafeArea(
          child: Runtime(
            // ignore: invalid_use_of_protected_member
            runtimeInfo: bloc?.disposeBag.whereType<BaseIO>().toList() ?? [],
          ),
        ),
      );
    }
    return Scaffold(
      key: key,
      floatingActionButtonLocation: floatingActionButtonLocation,
      floatingActionButtonAnimator: floatingActionButtonAnimator,
      persistentFooterButtons: persistentFooterButtons,
      backgroundColor: backgroundColor,
      primary: primary,
      appBar: appBar,
      body: body,
      floatingActionButton: floatingActionButton,
      drawer: drawer,
      endDrawer: runtimeInfoWidget,
      bottomNavigationBar: bottomNavigationBar,
      bottomSheet: bottomSheet,
    );
  }
}
