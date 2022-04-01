import 'package:flutter/cupertino.dart';
import 'package:rxdart/rxdart.dart';

import '../utils/objects.dart';

mixin DebounceableMixin<T extends StatefulWidget> on State<T> {
  final _subject = BehaviorSubject<dynamic>.seeded(anyObject);

  abstract Duration debounceTime;

  @protected
  void onDebounced();

  /// 阻止防抖发生
  @protected
  void preventDebounce() {
    _subject.add(anyObject);
  }

  @override
  void initState() {
    super.initState();
    _subject.debounceTime(debounceTime).listen((_) {
      if (mounted) {
        onDebounced();
      }
    });
  }

  @override
  void dispose() {
    _subject.close();
    super.dispose();
  }
}
