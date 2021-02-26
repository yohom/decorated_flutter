import 'package:decorated_flutter/decorated_flutter.dart';
import 'package:decorated_flutter/src/bloc/bloc.export.dart';
import 'package:flutter/cupertino.dart';

mixin DisposeBag<T extends StatefulWidget> on State<T> {
  final CompositeSubscription disposeBag = CompositeSubscription();

  @override
  void dispose() {
    if (!disposeBag.isDisposed) disposeBag.dispose();
    super.dispose();
  }
}

mixin BLoCDisposeBag on BLoC {
  final CompositeSubscription disposeBag = CompositeSubscription();

  @override
  void dispose() {
    if (!disposeBag.isDisposed) disposeBag.dispose();
    super.dispose();
  }
}
