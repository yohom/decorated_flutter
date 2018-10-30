import 'package:flutter/material.dart';
import 'package:framework/framework.dart';
import 'package:framework/src/ui/runtime.widget.dart';

class RuntimeScaffold extends StatelessWidget {
  const RuntimeScaffold({
    Key key,
    @required this.bloc,
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
  })  : assert(primary != null),
        super(key: key);

  final LocalBLoC bloc;

  //region Scaffold
  final PreferredSizeWidget appBar;

  final Widget body;

  final Widget floatingActionButton;

  final FloatingActionButtonLocation floatingActionButtonLocation;

  final FloatingActionButtonAnimator floatingActionButtonAnimator;

  final List<Widget> persistentFooterButtons;

  final Widget drawer;

  final Color backgroundColor;

  final Widget bottomNavigationBar;

  final Widget bottomSheet;

  final bool resizeToAvoidBottomPadding;

  final bool primary;

  //endregion

  @override
  Widget build(BuildContext context) {
    Widget runtimeInfoWidget;
    if (isNotEmpty(bloc.eventList) &&
        !bool.fromEnvironment('dart.vm.product')) {
      runtimeInfoWidget = Drawer(child: Runtime(runtimeInfo: bloc.eventList));
    }
    return Scaffold(
      key: key,
      appBar: appBar,
      body: body,
      floatingActionButton: floatingActionButton,
      floatingActionButtonLocation: floatingActionButtonLocation,
      floatingActionButtonAnimator: floatingActionButtonAnimator,
      persistentFooterButtons: persistentFooterButtons,
      drawer: drawer,
      endDrawer: runtimeInfoWidget,
      backgroundColor: backgroundColor,
      bottomNavigationBar: bottomNavigationBar,
      bottomSheet: bottomSheet,
      resizeToAvoidBottomPadding: resizeToAvoidBottomPadding,
      primary: primary,
    );
  }
}
