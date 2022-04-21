import 'dart:developer' as devtools show log;

extension ObjectX on Object {
  void log([String? prefix]) => devtools.log('$prefix${toString()}');
}
