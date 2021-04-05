import 'package:decorated_flutter/decorated_flutter.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';

typedef String Converter<T>(T data);

Future<T> showPickerDialog<T>(
  BuildContext context, {
  @required List<T> data,
  String title,
  @required Converter<T> converter,
  TextStyle titleStyle,
  TextStyle confirmStyle,
}) {
  return showModalBottomSheet<T>(
    context: context,
    builder: (context) => _PickerDialog<T>(
      data,
      title: title,
      titleStyle: titleStyle,
      confirmStyle: confirmStyle,
      converter: converter,
    ),
  );
}

class _PickerDialog<T> extends StatefulWidget {
  const _PickerDialog(
    this._dataList, {
    Key key,
    this.title,
    this.titleStyle,
    this.confirmStyle,
    @required this.converter,
  }) : super(key: key);

  final List<T> _dataList;
  final String title;
  final Converter<T> converter;
  final TextStyle titleStyle;
  final TextStyle confirmStyle;

  @override
  _PickerDialogState createState() => _PickerDialogState<T>();
}

class _PickerDialogState<T> extends State<_PickerDialog<T>> {
  T _selected;

  @override
  void initState() {
    super.initState();
    _selected = widget._dataList[0];
  }

  @override
  Widget build(BuildContext context) {
    return DecoratedColumn(
      height: 256,
      children: <Widget>[
        DecoratedRow(
          children: <Widget>[
            FlatButton(
              onPressed: context.rootNavigator.pop,
              child: Text('取消'),
            ),
            Spacer(),
            if (isNotEmpty(widget.title))
              Text(
                widget.title,
                style: widget.titleStyle ?? context.textTheme.bodyText1,
              ),
            Spacer(),
            FlatButton(
              onPressed: () => context.rootNavigator.pop(_selected),
              child: Text(
                '确定',
                style: widget.confirmStyle ?? context.textTheme.bodyText1,
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
            itemExtent: 32,
            children: <Widget>[
              for (final item in widget._dataList)
                Text(widget.converter(item) ?? "")
            ],
          ),
        ),
      ],
    );
  }
}
