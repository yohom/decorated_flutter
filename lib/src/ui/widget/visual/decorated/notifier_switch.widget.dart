import 'package:flutter/cupertino.dart';

typedef ReactiveSwitch = NotifierSwitch;

class NotifierSwitch extends StatelessWidget {
  const NotifierSwitch(this._notifier, {super.key});

  final ValueNotifier<bool> _notifier;

  @override
  Widget build(BuildContext context) {
    return ValueListenableBuilder<bool>(
      valueListenable: _notifier,
      builder: (_, value, __) {
        return CupertinoSwitch(
          value: value,
          onChanged: (value) => _notifier.value = value,
        );
      },
    );
  }
}
