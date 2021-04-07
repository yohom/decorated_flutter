import 'package:decorated_flutter/decorated_flutter.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';

Future<DateTime> showDateDialog(
  BuildContext context, {
  DateTime initialDateTime,
  CupertinoDatePickerMode mode = CupertinoDatePickerMode.date,
  String cancelText,
  String confirmText,
}) async {
  return showModalBottomSheet(
    context: context,
    builder: (context) => _DatePickerDialog(
      initialDateTime: initialDateTime,
      mode: mode,
      cancelText: cancelText,
      confirmText: confirmText,
    ),
  );
}

class _DatePickerDialog extends StatefulWidget {
  const _DatePickerDialog({
    Key key,
    this.initialDateTime,
    this.mode,
    this.cancelText,
    this.confirmText,
  }) : super(key: key);

  final DateTime initialDateTime;
  final CupertinoDatePickerMode mode;
  final String cancelText;
  final String confirmText;

  @override
  __DatePickerDialogState createState() => __DatePickerDialogState();
}

class __DatePickerDialogState extends State<_DatePickerDialog> {
  DateTime _date;

  @override
  void initState() {
    super.initState();
    _date = widget.initialDateTime ?? DateTime.now();
  }

  @override
  Widget build(BuildContext context) {
    return DecoratedColumn(
      height: 256,
      children: [
        DecoratedRow(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: <Widget>[
            FlatButton(
              onPressed: () => _handleCancel(context),
              child: Text(
                widget.cancelText ?? '取消',
                style: context.textTheme.bodyText1.copyWith(color: Colors.red),
              ),
            ),
            FlatButton(
              onPressed: () => _handleConfirm(context),
              child: Text(widget.confirmText ?? '确认'),
            ),
          ],
        ),
        kDivider1,
        Expanded(
          child: CupertinoDatePicker(
            mode: widget.mode ?? CupertinoDatePickerMode.date,
            maximumDate: DateTime.now(),
            initialDateTime: _date,
            onDateTimeChanged: (date) {
              L.d('date: $date');
              _date = date;
            },
          ),
        ),
      ],
    );
  }

  void _handleCancel(BuildContext context) {
    context.rootNavigator.pop();
  }

  void _handleConfirm(BuildContext context) {
    // 点了确认, 日期却是null, 说明就是没有滚动过, 直接使用今天
    context.rootNavigator.pop(_date ?? DateTime.now());
  }
}
