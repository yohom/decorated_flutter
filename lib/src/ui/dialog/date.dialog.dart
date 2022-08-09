import 'dart:io';

import 'package:decorated_flutter/decorated_flutter.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';

Future<DateTime?> showDateDialog(
  BuildContext context, {
  DateTime? initialDateTime,
  DateTime? maximumDate,
  Widget? title,
  CupertinoDatePickerMode mode = CupertinoDatePickerMode.date,
  String? cancelText,
  String? confirmText,
}) async {
  return showModalBottomSheet<DateTime>(
    context: context,
    builder: (context) => _DatePickerDialog(
      initialDateTime: initialDateTime,
      maximumDate: maximumDate,
      title: title,
      mode: mode,
      cancelText: cancelText,
      confirmText: confirmText,
    ),
  );
}

class _DatePickerDialog extends StatefulWidget {
  const _DatePickerDialog({
    Key? key,
    this.initialDateTime,
    this.maximumDate,
    this.title,
    this.mode = CupertinoDatePickerMode.date,
    this.cancelText,
    this.confirmText,
  }) : super(key: key);

  final DateTime? initialDateTime;
  final DateTime? maximumDate;
  final Widget? title;
  final CupertinoDatePickerMode mode;
  final String? cancelText;
  final String? confirmText;

  @override
  __DatePickerDialogState createState() => __DatePickerDialogState();
}

class __DatePickerDialogState extends State<_DatePickerDialog> {
  late DateTime _date;

  @override
  void initState() {
    super.initState();
    _date = widget.initialDateTime ?? DateTime.now();
  }

  @override
  Widget build(BuildContext context) {
    final chinese = Platform.localeName.contains('zh');
    return DecoratedColumn(
      height: 256 + context.padding.bottom,
      safeArea: const SafeAreaConfig.bottom(),
      children: [
        DecoratedRow(
          padding: const EdgeInsets.symmetric(horizontal: 8),
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: <Widget>[
            TextButton(
              onPressed: () => _handleCancel(context),
              child: Text(
                widget.cancelText ?? (chinese ? '取消' : 'Cancel'),
                style: context.textTheme.bodyText1!.copyWith(color: Colors.red),
              ),
            ),
            if (widget.title != null) widget.title!,
            TextButton(
              onPressed: () => _handleConfirm(context),
              child: Text(widget.confirmText ?? (chinese ? '确定' : 'Confirm')),
            ),
          ],
        ),
        kDivider1,
        Expanded(
          child: CupertinoDatePicker(
            mode: widget.mode,
            maximumDate: widget.maximumDate,
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
    context.rootNavigator.pop(_date);
  }
}
