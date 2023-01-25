import 'package:decorated_flutter/decorated_flutter.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';

typedef Converter<T> = String Function(T data);

Future<T?> showPickerDialog<T>(
  BuildContext context, {
  required List<T> data,
  String? title,
  TextStyle? titleStyle,
  TextStyle? confirmStyle,
  required Widget Function(T) itemBuilder,
  double itemExtent = 32,
}) {
  return showModalBottomSheet<T>(
    context: context,
    builder: (context) => _PickerDialog<T>(
      data,
      title: title,
      titleStyle: titleStyle,
      confirmStyle: confirmStyle,
      itemBuilder: itemBuilder,
      itemExtent: itemExtent,
    ),
  );
}

class _PickerDialog<T> extends StatefulWidget {
  const _PickerDialog(
    this._dataList, {
    Key? key,
    this.title,
    this.titleStyle,
    this.confirmStyle,
    required this.itemBuilder,
    required this.itemExtent,
  }) : super(key: key);

  final List<T> _dataList;
  final String? title;
  final TextStyle? titleStyle;
  final TextStyle? confirmStyle;
  final Widget Function(T) itemBuilder;
  final double itemExtent;

  @override
  _PickerDialogState createState() => _PickerDialogState<T>();
}

class _PickerDialogState<T> extends State<_PickerDialog<T>> {
  late T _selected;

  @override
  void initState() {
    super.initState();
    _selected = widget._dataList[0];
  }

  @override
  Widget build(BuildContext context) {
    return DecoratedColumn(
      height: 256,
      color: context.backgroundColor,
      children: <Widget>[
        DecoratedRow(
          color: context.theme.colorScheme.surface,
          children: <Widget>[
            TextButton(
              onPressed: context.rootNavigator.pop,
              child: const Text('取消'),
            ),
            const Spacer(),
            if (isNotEmpty(widget.title))
              Text(
                widget.title!,
                style: widget.titleStyle ?? context.textTheme.bodyLarge,
              ),
            const Spacer(),
            TextButton(
              onPressed: () => context.rootNavigator.pop(_selected),
              child: Text(
                '确定',
                style: widget.confirmStyle ?? context.textTheme.bodyLarge,
              ),
            ),
          ],
        ),
        kDivider1,
        Flexible(
          child: CupertinoPicker(
            onSelectedItemChanged: (int value) {
              setState(() {
                _selected = widget._dataList[value];
              });
            },
            itemExtent: widget.itemExtent,
            children: <Widget>[
              for (final item in widget._dataList) widget.itemBuilder(item)
            ],
          ),
        ),
      ],
    );
  }
}
