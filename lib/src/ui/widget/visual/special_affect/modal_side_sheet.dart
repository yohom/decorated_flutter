import 'package:flutter/material.dart';

const _kDefaultWidth = 400.0;
const _kDefaultThickness = 2.0;

/// An implementaion of Material Side Sheet suggested by Google.
/// Generally to be used with [Scaffold]'s body property.
/// Should only to be used within Web or Desktop.
/// #### Example :
/// ```dart
/// @override
///   Widget build(BuildContext context) {
///     return Scaffold(
///       body: BodyWithSideSheet(
///           show: true,
///           body: Container(
///             child: Text("My App Body"),
///           ),
///           sheetBody: Container(
///             child: Text("Side Sheet body"),
///           )),
///     );
///   }
/// ```
/// See also : https://material.io/components/sheets-side#standard-side-sheet
class BodyWithSideSheet extends StatelessWidget {
  const BodyWithSideSheet({
    super.key,
    this.show = false,
    required this.body,
    this.sheetWidth = _kDefaultWidth,
    required this.sheetBody,
  });

  /// App body referred as [Scaffold.body]
  final Widget body;

  /// State of the Side sheet, whether to show side sheet or not.
  /// Change it using [setState()]
  final bool show;

  /// The width of the Side sheet to be covered by the `sheetBody`
  final double? sheetWidth;

  /// The body of the side sheet. Typically a [Widget].
  final Widget sheetBody;
  @override
  Widget build(BuildContext context) {
    return Row(
      mainAxisSize: MainAxisSize.max,
      mainAxisAlignment: MainAxisAlignment.start,
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Expanded(child: body),
        if (show)
          SizedBox(
            width: _kDefaultThickness,
            child: Center(
              child: Container(
                width: _kDefaultThickness,
                decoration: BoxDecoration(
                  border: Border(
                    left: Divider.createBorderSide(context,
                        color: Theme.of(context).dividerColor,
                        width: _kDefaultThickness),
                  ),
                ),
              ),
            ),
          ),
        _ShrinkableSize(
            show: show,
            child: SizedBox(
                width: sheetWidth,
                height: MediaQuery.of(context).size.height,
                child: sheetBody)),
      ],
    );
  }
}

class _ShrinkableSize extends StatefulWidget {
  const _ShrinkableSize({required this.child, required this.show});

  /// The child of the [_ShrinkableSize] widget.
  final Widget child;

  /// Whether to shrink or not.
  final bool show;
  @override
  __ShrinkableSizeState createState() => __ShrinkableSizeState();
}

class __ShrinkableSizeState extends State<_ShrinkableSize>
    with SingleTickerProviderStateMixin {
  late AnimationController controller;
  late Animation<double> animation;
  @override
  void initState() {
    controller = AnimationController(
        vsync: this, duration: const Duration(milliseconds: 300));
    super.initState();
    animation = Tween<double>(begin: 0, end: 1).animate(controller);
  }

  @override
  void dispose() {
    controller.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    widget.show ? controller.forward() : controller.reverse();
    return SizeTransition(
      sizeFactor: animation,
      axis: Axis.horizontal,
      child: widget.child,
    );
  }
}

/// Displays a Material Side Sheet transitioned from Right side of the screen.
///
/// This function allows for customization of aspects of the Modal Side Sheet.
///
/// This function takes a `body` which is used to build the primary
/// content of the side sheet (typically a widget). Content below the side sheet
/// is dimmed with a [ModalBarrier]. The widget returned by the `body`
/// does not share a context with the location that `showModalSideSheet` is
/// originally called from. Use a [StatefulBuilder] or a custom
/// [StatefulWidget] if the side sheet needs to update dynamically. The
/// `body` argument cannot be null.
///
/// ### Note :
/// `ignoreAppBar` perameter determines that whether to show side sheet beneath the
/// [AppBar] or not. Default value of this perameter is `true`.
/// If this perameter set to `false`, the widget where you are calling[showModalSideSheet]
/// cannot be the direct child of the [Scaffold].
/// You must use a custom [Widget] or Wrap the used widget into [Builder] widget.
///
/// ##
/// `withCloseControll` perameter provide a Close Button on top right corner of the
/// side sheet to manually close the Modal Side Sheet. Default value is true.
/// If provided `false` you need to call [Navigator.of(context).pop()] method to close
/// the side sheet.
///
/// ##
/// `width` perameter gives a Width to the side sheet. For mobile devices default is 60%
/// of the device width and 25% for rest of the devices.
///
/// ## See Also
/// * The `context` argument is used to look up the [Navigator] for the
/// side sheet. It is only used when the method is called. Its corresponding widget
/// can be safely removed from the tree before the side sheet is closed.
///
/// * The `useRootNavigator` argument is used to determine whether to push the
/// side sheet to the [Navigator] furthest from or nearest to the given `context`.
/// By default, `useRootNavigator` is `true` and the side sheet route created by
/// this method is pushed to the root navigator.
///
/// * If the application has multiple [Navigator] objects, it may be necessary to
/// call `Navigator.of(context, rootNavigator: true).pop(result)` to close the
/// side sheet rather than just `Navigator.pop(context, result)`.
///
/// * The `barrierDismissible` argument is used to determine whether this route
/// can be dismissed by tapping the modal barrier. This argument defaults
/// to false. If `barrierDismissible` is true, a non-null `barrierLabel` must be
/// provided.
///
/// * The `barrierLabel` argument is the semantic label used for a dismissible
/// barrier. This argument defaults to `null`.
///
/// * The `barrierColor` argument is the color used for the modal barrier. This
/// argument defaults to `Color(0x80000000)`.
///
/// * The `transitionDuration` argument is used to determine how long it takes
/// for the route to arrive on or leave off the screen. This argument defaults
/// to 300 milliseconds.
///
/// * The `transitionBuilder` argument is used to define how the route arrives on
/// and leaves off the screen. By default, the transition is a linear fade of
/// the page's contents.
///
/// * The `routeSettings` will be used in the construction of the side sheet's route.
/// See [RouteSettings] for more details.
///
/// * Returns a [Future] that resolves to the value (if any) that was passed to
/// [Navigator.pop] when the side sheet was closed.
///
/// ##
/// * For more info on Modal Side Sheet see also : https://material.io/components/sheets-side#modal-side-sheet

Future<T?> showModalSideSheet<T extends Object?>({
  required BuildContext context,
  required Widget body,
  bool barrierDismissible = false,
  Color barrierColor = const Color(0x80000000),
  double? width,
  double elevation = 8.0,
  Duration transitionDuration = const Duration(milliseconds: 300),
  String? barrierLabel = "Side Sheet",
  bool useRootNavigator = true,
  RouteSettings? routeSettings,
  bool ignoreAppBar = true,
  Color? backgroundColor,
}) {
  var of = MediaQuery.of(context);
  var platform = Theme.of(context).platform;
  if (width == null) {
    if (platform == TargetPlatform.android || platform == TargetPlatform.iOS) {
      width = of.size.width * 0.6;
    } else {
      width = of.size.width / 4;
    }
  }
  double exceptionalheight = !ignoreAppBar
      ? Scaffold.of(context).hasAppBar
          ? Scaffold.of(context).appBarMaxHeight!
          : 0
      : 0;
  double height = of.size.height - exceptionalheight;
  assert(!barrierDismissible || barrierLabel != null);
  return showGeneralDialog(
    barrierDismissible: barrierDismissible,
    barrierColor: barrierColor,
    transitionDuration: transitionDuration,
    barrierLabel: barrierLabel,
    useRootNavigator: useRootNavigator,
    routeSettings: routeSettings,
    context: context,
    pageBuilder: (BuildContext context, _, __) {
      return Align(
        alignment: Alignment.bottomRight,
        child: Material(
          elevation: elevation,
          color: backgroundColor ?? Colors.white,
          child: SizedBox(width: width, height: height, child: body),
        ),
      );
    },
    transitionBuilder: (_, animation, __, child) {
      return SlideTransition(
        position: Tween<Offset>(begin: const Offset(1, 0), end: Offset.zero)
            .animate(animation),
        child: child,
      );
    },
  );
}
