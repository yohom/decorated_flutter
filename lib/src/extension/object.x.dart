import 'dart:developer' as devtools show log;

extension ObjectX on Object {
  void log([String? prefix]) => devtools.log('$prefix${toString()}');
}

extension KtStandardExtension<T> on T {
  R let<R>(R Function(T self) block) {
    return block(this);
  }

  T apply(void Function() block) {
    block();
    return this;
  }

  R also<R>(R Function(T self) func) {
    return func(this);
  }

  R run<R>(R Function() func) {
    return func();
  }

  T? takeIf(bool Function(T self) predicate) {
    if (predicate(this)) {
      return this;
    } else {
      return null;
    }
  }
}
