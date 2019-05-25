import 'dart:async';

mixin DisposeBag on Object {
  List<StreamSubscription> disposeBag = [];
}
