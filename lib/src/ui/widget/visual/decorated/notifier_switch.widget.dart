import 'package:cupertino_ui/cupertino_ui.dart';

typedef ReactiveSwitch = NotifierSwitch;

class NotifierSwitch extends StatelessWidget {
  const NotifierSwitch(this._notifier, {super.key});

  final ValueNotifier<bool> _notifier;

  @override
  Widget build(BuildContext context) {
    return ValueListenableBuilder<bool>(
      valueListenable: _notifier,
      builder: (_, value, _) {
        return CupertinoSwitch(
          value: value,
          onChanged: (value) => _notifier.value = value,
        );
      },
    );
  }
}
