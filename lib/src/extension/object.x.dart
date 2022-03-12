import 'dart:developer' as devtools show log;

extension on Object {
  void log() => devtools.log(toString());
}
