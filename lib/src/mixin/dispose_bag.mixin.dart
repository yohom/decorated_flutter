import 'dart:async';

import 'package:decorated_flutter/src/bloc/bloc.export.dart';
import 'package:flutter/cupertino.dart';

mixin DisposeBag<T extends StatefulWidget> on State<T> {
  List<StreamSubscription> disposeBag = [];

  @override
  void dispose() {
    disposeBag.forEach((it) => it.cancel());
    super.dispose();
  }
}

mixin BLoCDisposeBag on BLoC {
  List<StreamSubscription> disposeBag = [];

  @override
  void dispose() {
    disposeBag.forEach((it) => it.cancel());
    super.dispose();
  }
}
